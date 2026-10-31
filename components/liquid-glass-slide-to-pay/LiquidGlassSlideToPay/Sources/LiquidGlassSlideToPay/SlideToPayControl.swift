import SwiftUI

/// Where the control is in the payment flow.
///
/// The control moves itself from `.idle` to `.processing` when the slide completes and calls
/// `onSlide`. The host starts the payment there, then sets the phase to `.complete` once the
/// payment is confirmed, or back to `.idle` if it fails or is cancelled. The control animates
/// each change.
public enum SlideToPayPhase: Equatable, Sendable {
    case idle
    case processing
    case complete
}

/// The Sam's Club "Slide to pay" control, rebuilt in Liquid Glass.
///
/// - The track is solid Club Blue, flat as in production. Glass is reserved for the knob and
///   the label: the knob is clear glass, so it lenses the label as it passes.
/// - While resting, the label shimmers the way the iOS 27 slide controls do. The capsule itself
///   does not shimmer.
/// - Dragging stretches the knob with velocity and leaves a lighter liquid fill behind it.
///   Releasing before `threshold` springs the knob back with a small overshoot.
/// - Past `threshold`, the knob parks at the end, its chevron becomes a progress ring, and the
///   label reads `processingTitle` while the host confirms the payment.
/// - On `.complete`, the knob swells leftward to fill the capsule and dissolves while the fill
///   turns to `completedTint` and the label reads `completedTitle`.
/// - VoiceOver treats it as an adjustable element and also offers a direct "Pay" action.
public struct SlideToPayControl: View {
    public var title: String
    public var processingTitle: String
    public var completedTitle: String
    /// Spoken after the title, for example "$148.45".
    public var amountDescription: String
    /// Solid track colour. Club Blue by default.
    public var tint: Color
    public var completedTint: Color
    public var height: CGFloat
    /// Fraction of the track the knob must pass before release starts the payment.
    public var threshold: CGFloat
    /// Shortest time the processing state stays visible, so an instant confirmation still reads.
    public var minimumProcessingDuration: TimeInterval
    @Binding public var phase: SlideToPayPhase
    /// Called once when the slide completes and the control enters `.processing`. Start the payment here.
    public var onSlide: () -> Void

    public init(
        title: String = "Slide to pay",
        processingTitle: String = "Placing your order",
        completedTitle: String = "Order placed",
        amountDescription: String = "",
        tint: Color = SamsClubColor.clubBlue,
        completedTint: Color = SamsClubColor.maverickGreen,
        height: CGFloat = 64,
        threshold: CGFloat = 0.88,
        minimumProcessingDuration: TimeInterval = 0.6,
        phase: Binding<SlideToPayPhase>,
        onSlide: @escaping () -> Void = {}
    ) {
        self.title = title
        self.processingTitle = processingTitle
        self.completedTitle = completedTitle
        self.amountDescription = amountDescription
        self.tint = tint
        self.completedTint = completedTint
        self.height = height
        self.threshold = threshold
        self.minimumProcessingDuration = minimumProcessingDuration
        self._phase = phase
        self.onSlide = onSlide
        SamsSans.registerFontsIfNeeded()
    }

    // MARK: - State

    @State private var dragX: CGFloat = 0
    @State private var dragStartX: CGFloat?
    @State private var stretch: CGFloat = 0
    @State private var stretchReset: Task<Void, Never>?
    @State private var measuredMaxX: CGFloat = 1
    @State private var showProcessing = false
    @State private var processingBegan: Date?
    @State private var completion: Task<Void, Never>?
    @State private var knobFills = false
    @State private var showCompleted = false
    @State private var lastTickQuarter = 0
    @State private var tickTrigger = 0
    @State private var startTrigger = 0
    @State private var successTrigger = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let knobInset: CGFloat = 4

    private var isIdle: Bool { phase == .idle }

    private var labelFont: Font { SamsSans.ui(19, weight: .semibold, relativeTo: .title3) }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let knobSize = height - knobInset * 2
            let maxX = max(trackWidth - knobSize - knobInset * 2, 1)
            let progress = min(max(dragX / maxX, 0), 1)
            let isDragging = dragStartX != nil

            ZStack(alignment: .leading) {
                track(progress: progress, isDragging: isDragging, knobSize: knobSize)
                knob(knobSize: knobSize, trackWidth: trackWidth, maxX: maxX)
            }
            .frame(width: trackWidth, height: height)
            .scaleEffect(isDragging ? 1.015 : 1)
            .animation(.easeOut(duration: 0.22), value: isDragging)
            .onChange(of: maxX, initial: true) { _, newValue in
                measuredMaxX = newValue
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(amountDescription.isEmpty ? title : "\(title), \(amountDescription)"))
            .accessibilityValue(Text(accessibilityValue(progress: progress)))
            .accessibilityHint(Text(isIdle ? "Swipe up to move the knob, or use the Pay action." : ""))
            .accessibilityAddTraits(phase == .processing ? .updatesFrequently : [])
            .accessibilityAdjustableAction { direction in
                guard isIdle else { return }
                let step = maxX / 10
                withAnimation(.easeOut(duration: 0.2)) {
                    switch direction {
                    case .increment: dragX = min(dragX + step, maxX)
                    case .decrement: dragX = max(dragX - step, 0)
                    @unknown default: break
                    }
                }
                if dragX >= maxX - 0.5 {
                    beginProcessing(maxX: maxX)
                }
            }
            .accessibilityAction(named: Text("Pay")) {
                guard isIdle else { return }
                beginProcessing(maxX: maxX)
            }
        }
        .frame(height: height)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.6), trigger: tickTrigger)
        .sensoryFeedback(.start, trigger: startTrigger)
        .sensoryFeedback(.success, trigger: successTrigger)
        .onChange(of: phase) { _, newPhase in
            handlePhaseChange(to: newPhase)
        }
    }

    private func accessibilityValue(progress: CGFloat) -> String {
        switch phase {
        case .idle: "\(Int(progress * 100)) percent"
        case .processing: processingTitle
        case .complete: completedTitle
        }
    }

    // MARK: - Track

    private func track(progress: CGFloat, isDragging: Bool, knobSize: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            // Displaced liquid trailing the knob.
            Capsule()
                .fill(.white.opacity(0.16))
                .frame(width: knobInset + dragX + knobSize / 2)
                .opacity(isIdle && progress > 0.01 ? 1 : 0)

            // Resting label: translucent white that the shimmer brightens, fading as the knob covers it.
            Text(title)
                .font(labelFont)
                .foregroundStyle(.white.opacity(0.62))
                .shimmer(ShimmerStyle(highlight: .white), isActive: isIdle && !isDragging)
                .opacity(isIdle ? max(0, 1 - progress * 1.9) : 0)
                .offset(x: progress * 18)
                .frame(maxWidth: .infinity)

            // Processing label: same treatment, with the shimmer a touch faster so it reads as activity.
            if showProcessing {
                Text(processingTitle)
                    .font(labelFont)
                    .foregroundStyle(.white.opacity(0.62))
                    .shimmer(ShimmerStyle(period: 1.1, highlight: .white))
                    .frame(maxWidth: .infinity)
                    .transition(.opacity)
            }

            // Completed label.
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                Text(completedTitle)
                    .font(labelFont)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .opacity(showCompleted ? 1 : 0)
            .offset(y: showCompleted ? 0 : 6)
        }
        .frame(maxWidth: .infinity)
        .frame(height: height)
        // Solid, flat track. No gradient, no glass: the knob and label carry the glass.
        .background(Capsule().fill(showCompleted ? completedTint : tint))
        .animation(.easeInOut(duration: 0.25), value: showProcessing)
        .animation(.easeInOut(duration: 0.4), value: showCompleted)
    }

    // MARK: - Knob

    private func knob(knobSize: CGFloat, trackWidth: CGFloat, maxX: CGFloat) -> some View {
        let width = knobFills ? trackWidth - knobInset * 2 : knobSize
        return ZStack {
            Image(systemName: "chevron.right")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(tint)
                .opacity(showProcessing || knobFills ? 0 : 1)
                .scaleEffect(showProcessing ? 0.6 : 1)
            if showProcessing && !knobFills {
                ProcessingRing(color: tint)
                    .transition(.opacity.combined(with: .scale(scale: 0.6)))
            }
        }
        .frame(width: width, height: knobSize)
        .liquidGlass(.clear, in: Capsule(), interactive: true)
        .scaleEffect(x: 1 + stretch, y: 1 - stretch * 0.55)
        .offset(x: knobInset + dragX)
        .opacity(showCompleted ? 0 : 1)
        .animation(.easeOut(duration: 0.25), value: showProcessing)
        .gesture(dragGesture(maxX: maxX))
        .allowsHitTesting(isIdle)
    }

    // MARK: - Gesture

    private func dragGesture(maxX: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                guard isIdle else { return }
                if dragStartX == nil { dragStartX = dragX }
                let start = dragStartX ?? 0
                dragX = min(max(start + value.translation.width, 0), maxX)

                // Stretch with velocity, like a droplet pulled along, then relax.
                if !reduceMotion {
                    let speed = abs(value.velocity.width) // points per second
                    withAnimation(.easeOut(duration: 0.12)) {
                        stretch = min(0.26, speed / 5000)
                    }
                    stretchReset?.cancel()
                    stretchReset = Task { @MainActor in
                        try? await Task.sleep(for: .milliseconds(90))
                        guard !Task.isCancelled else { return }
                        withAnimation(.easeOut(duration: 0.2)) { stretch = 0 }
                    }
                }

                // A soft tick at each quarter of the track.
                let quarter = Int(dragX / maxX * 4)
                if quarter != lastTickQuarter {
                    lastTickQuarter = quarter
                    tickTrigger += 1
                }
            }
            .onEnded { _ in
                guard isIdle else { return }
                dragStartX = nil
                stretchReset?.cancel()
                if dragX / maxX >= threshold {
                    beginProcessing(maxX: maxX)
                } else {
                    let springBack: Animation = reduceMotion
                        ? .linear(duration: 0)
                        : .spring(response: 0.45, dampingFraction: 0.6)
                    withAnimation(springBack) {
                        dragX = 0
                        stretch = 0
                    }
                    lastTickQuarter = 0
                }
            }
    }

    // MARK: - Phases

    /// The user completed the slide: park the knob, show the ring, hand off to the host.
    private func beginProcessing(maxX: CGFloat) {
        guard isIdle else { return }
        dragStartX = nil
        stretchReset?.cancel()
        enterProcessing(maxX: maxX)
        startTrigger += 1
        phase = .processing
        onSlide()
    }

    /// Visual side of processing. Idempotent, so an external `.processing` looks the same as a slide.
    private func enterProcessing(maxX: CGFloat) {
        guard !showProcessing else { return }
        let snap: Animation = reduceMotion ? .linear(duration: 0) : .spring(response: 0.28, dampingFraction: 0.8)
        withAnimation(snap) {
            dragX = maxX
            stretch = 0
        }
        processingBegan = Date()
        showProcessing = true
        AccessibilityNotification.Announcement(processingTitle).post()
    }

    private func handlePhaseChange(to newPhase: SlideToPayPhase) {
        switch newPhase {
        case .idle:
            reset()
        case .processing:
            enterProcessing(maxX: measuredMaxX)
        case .complete:
            scheduleCompletion()
        }
    }

    /// Runs the completion morph, holding the processing state for `minimumProcessingDuration` first.
    private func scheduleCompletion() {
        completion?.cancel()
        let elapsed = processingBegan.map { Date().timeIntervalSince($0) } ?? minimumProcessingDuration
        let wait = max(0, minimumProcessingDuration - elapsed)
        completion = Task { @MainActor in
            if wait > 0 {
                try? await Task.sleep(for: .seconds(wait))
            }
            guard !Task.isCancelled else { return }
            runCompletion()
        }
    }

    private func runCompletion() {
        successTrigger += 1

        let instant = Animation.linear(duration: 0)
        let snap = reduceMotion ? instant : .spring(response: 0.28, dampingFraction: 0.8)
        let swell = reduceMotion ? instant : .spring(response: 0.5, dampingFraction: 0.85)
        let reveal = reduceMotion ? instant : .easeInOut(duration: 0.35)
        let maxX = measuredMaxX

        withAnimation(snap) {
            dragX = maxX
            stretch = 0
        }
        withAnimation(.easeOut(duration: 0.2)) {
            showProcessing = false
        }
        AccessibilityNotification.Announcement(completedTitle).post()

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(reduceMotion ? 0 : 160))
            // The knob swells leftward into the capsule from the right end.
            withAnimation(swell) {
                knobFills = true
                dragX = 0
            }
            try? await Task.sleep(for: .milliseconds(reduceMotion ? 0 : 260))
            withAnimation(reveal) {
                showCompleted = true
            }
        }
    }

    /// Back to idle from any phase. From processing this is the payment failing or being cancelled.
    private func reset() {
        completion?.cancel()
        stretchReset?.cancel()
        processingBegan = nil
        let settle: Animation = reduceMotion ? .linear(duration: 0) : .spring(response: 0.45, dampingFraction: 0.7)
        withAnimation(settle) {
            showCompleted = false
            showProcessing = false
            knobFills = false
            dragX = 0
            stretch = 0
        }
        dragStartX = nil
        lastTickQuarter = 0
    }
}

/// Indeterminate progress ring shown in the knob while the payment is processing.
struct ProcessingRing: View {
    var color: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if reduceMotion {
            ProgressView()
                .tint(color)
        } else {
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate
                let turn = elapsed.truncatingRemainder(dividingBy: 0.9) / 0.9
                Circle()
                    .trim(from: 0, to: 0.72)
                    .stroke(color, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: 22, height: 22)
                    .rotationEffect(.degrees(turn * 360))
            }
        }
    }
}

// MARK: - Previews

#Preview("Control") {
    struct Host: View {
        @State private var phase: SlideToPayPhase = .idle
        var body: some View {
            VStack(spacing: 24) {
                SlideToPayControl(amountDescription: "$148.45", phase: $phase) {
                    // Stand-in for the payment service: confirm after 1.6 s.
                    Task {
                        try? await Task.sleep(for: .seconds(1.6))
                        phase = .complete
                    }
                }
                Button("Reset") { phase = .idle }
                    .disabled(phase == .idle)
            }
            .padding(24)
        }
    }
    return Host()
}

#Preview("Payment fails") {
    struct Host: View {
        @State private var phase: SlideToPayPhase = .idle
        var body: some View {
            SlideToPayControl(amountDescription: "$148.45", phase: $phase) {
                // The service declines after 1.6 s: the control springs back to idle.
                Task {
                    try? await Task.sleep(for: .seconds(1.6))
                    phase = .idle
                }
            }
            .padding(24)
        }
    }
    return Host()
}
