import SwiftUI

/// The Sam's Club "Slide to pay" control, rebuilt in Liquid Glass.
///
/// - The track is solid Club Blue, flat as in production. Glass is reserved for the knob and
///   the label: the knob is clear glass, so it lenses the label as it passes.
/// - While resting, the label shimmers the way the iOS 27 slide controls do. The capsule itself
///   does not shimmer.
/// - Dragging stretches the knob with velocity and leaves a lighter liquid fill behind it.
///   Releasing before `threshold` springs the knob back with a small overshoot.
/// - Past `threshold`, the knob swells leftward to fill the capsule and dissolves while the
///   tint turns to `completedTint` and the label reads `completedTitle`.
/// - VoiceOver treats it as an adjustable element and also offers a direct "Pay" action.
public struct SlideToPayControl: View {
    public var title: String
    public var completedTitle: String
    /// Spoken after the title, for example "$148.45".
    public var amountDescription: String
    /// Solid track colour. Club Blue by default.
    public var tint: Color
    public var completedTint: Color
    public var height: CGFloat
    /// Fraction of the track the knob must pass before release completes the payment.
    public var threshold: CGFloat
    @Binding public var isComplete: Bool
    public var onComplete: () -> Void

    public init(
        title: String = "Slide to pay",
        completedTitle: String = "Order placed",
        amountDescription: String = "",
        tint: Color = SamsClubColor.clubBlue,
        completedTint: Color = SamsClubColor.maverickGreen,
        height: CGFloat = 64,
        threshold: CGFloat = 0.88,
        isComplete: Binding<Bool>,
        onComplete: @escaping () -> Void = {}
    ) {
        self.title = title
        self.completedTitle = completedTitle
        self.amountDescription = amountDescription
        self.tint = tint
        self.completedTint = completedTint
        self.height = height
        self.threshold = threshold
        self._isComplete = isComplete
        self.onComplete = onComplete
        SamsSans.registerFontsIfNeeded()
    }

    // MARK: - State

    @State private var dragX: CGFloat = 0
    @State private var dragStartX: CGFloat?
    @State private var stretch: CGFloat = 0
    @State private var stretchReset: Task<Void, Never>?
    @State private var knobFills = false
    @State private var showCompleted = false
    @State private var lastTickQuarter = 0
    @State private var tickTrigger = 0
    @State private var successTrigger = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let knobInset: CGFloat = 4

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
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(amountDescription.isEmpty ? title : "\(title), \(amountDescription)"))
            .accessibilityValue(Text(isComplete ? completedTitle : "\(Int(progress * 100)) percent"))
            .accessibilityHint(Text(isComplete ? "" : "Swipe up to move the knob, or use the Pay action."))
            .accessibilityAdjustableAction { direction in
                guard !isComplete else { return }
                let step = maxX / 10
                withAnimation(.easeOut(duration: 0.2)) {
                    switch direction {
                    case .increment: dragX = min(dragX + step, maxX)
                    case .decrement: dragX = max(dragX - step, 0)
                    @unknown default: break
                    }
                }
                if dragX >= maxX - 0.5 {
                    complete(maxX: maxX)
                }
            }
            .accessibilityAction(named: Text("Pay")) {
                guard !isComplete else { return }
                complete(maxX: maxX)
            }
        }
        .frame(height: height)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.6), trigger: tickTrigger)
        .sensoryFeedback(.success, trigger: successTrigger)
        .onChange(of: isComplete) { _, nowComplete in
            if !nowComplete { reset() }
        }
    }

    // MARK: - Track

    private func track(progress: CGFloat, isDragging: Bool, knobSize: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            // Displaced liquid trailing the knob.
            Capsule()
                .fill(.white.opacity(0.16))
                .frame(width: knobInset + dragX + knobSize / 2)
                .opacity(progress > 0.01 && !showCompleted ? 1 : 0)

            // Resting label: translucent white that the shimmer brightens, fading as the knob covers it.
            Text(title)
                .font(SamsSans.ui(19, weight: .semibold, relativeTo: .title3))
                .foregroundStyle(.white.opacity(0.62))
                .shimmer(ShimmerStyle(highlight: .white), isActive: !isDragging && !isComplete)
                .opacity(max(0, 1 - progress * 1.9))
                .offset(x: progress * 18)
                .frame(maxWidth: .infinity)

            // Completed label.
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .font(.system(size: 20, weight: .bold))
                Text(completedTitle)
                    .font(SamsSans.ui(19, weight: .semibold, relativeTo: .title3))
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
        .animation(.easeInOut(duration: 0.4), value: showCompleted)
    }

    // MARK: - Knob

    private func knob(knobSize: CGFloat, trackWidth: CGFloat, maxX: CGFloat) -> some View {
        let width = knobFills ? trackWidth - knobInset * 2 : knobSize
        return Image(systemName: "chevron.right")
            .font(.system(size: 22, weight: .bold))
            .foregroundStyle(tint)
            .opacity(knobFills ? 0 : 1)
            .frame(width: width, height: knobSize)
            .liquidGlass(.clear, in: Capsule(), interactive: true)
            .scaleEffect(x: 1 + stretch, y: 1 - stretch * 0.55)
            .offset(x: knobInset + dragX)
            .opacity(showCompleted ? 0 : 1)
            .gesture(dragGesture(maxX: maxX))
            .allowsHitTesting(!isComplete)
    }

    // MARK: - Gesture

    private func dragGesture(maxX: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { value in
                guard !isComplete else { return }
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
                dragStartX = nil
                stretchReset?.cancel()
                if dragX / maxX >= threshold {
                    complete(maxX: maxX)
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

    // MARK: - Completion

    private func complete(maxX: CGFloat) {
        isComplete = true
        successTrigger += 1

        let instant = Animation.linear(duration: 0)
        let snap = reduceMotion ? instant : .spring(response: 0.28, dampingFraction: 0.8)
        let swell = reduceMotion ? instant : .spring(response: 0.5, dampingFraction: 0.85)
        let reveal = reduceMotion ? instant : .easeInOut(duration: 0.35)

        withAnimation(snap) {
            dragX = maxX
            stretch = 0
        }
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
        onComplete()
    }

    private func reset() {
        stretchReset?.cancel()
        withAnimation(.easeOut(duration: 0.25)) {
            showCompleted = false
            knobFills = false
            dragX = 0
            stretch = 0
        }
        dragStartX = nil
        lastTickQuarter = 0
    }
}

// MARK: - Previews

#Preview("Control") {
    struct Host: View {
        @State private var done = false
        var body: some View {
            VStack(spacing: 24) {
                SlideToPayControl(amountDescription: "$148.45", isComplete: $done)
                Button("Reset") { done = false }
                    .disabled(!done)
            }
            .padding(24)
        }
    }
    return Host()
}
