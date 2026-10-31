import SwiftUI

/// The iOS "slide to unlock" label treatment: a soft highlight sweeps across the text on a
/// fixed cadence while the control rests.
///
/// Defaults are measured from the iOS 27 power-off screen: one pass every 1.6 s, the band
/// about a third of the label's width, linear motion, and the band starts and ends fully
/// outside the text so each pass fades in and out.
public struct ShimmerStyle: Sendable {
    /// Seconds for one full pass, including the time the band is off the text.
    public var period: TimeInterval
    /// Band width as a fraction of the shimmered view's width.
    public var bandFraction: CGFloat
    /// Colour the text brightens to inside the band.
    public var highlight: Color

    public init(period: TimeInterval = 1.6, bandFraction: CGFloat = 0.35, highlight: Color = .white) {
        self.period = period
        self.bandFraction = bandFraction
        self.highlight = highlight
    }

    public static let standard = ShimmerStyle()
}

/// Overlays a highlight-coloured silhouette of the content and masks it with a moving band.
/// Works on any view, text or symbols. Respects Reduce Motion by rendering the content plainly.
public struct Shimmer: ViewModifier {
    public var style: ShimmerStyle
    public var isActive: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    public init(style: ShimmerStyle = .standard, isActive: Bool = true) {
        self.style = style
        self.isActive = isActive
    }

    public func body(content: Content) -> some View {
        if isActive && !reduceMotion {
            TimelineView(.animation) { timeline in
                let elapsed = timeline.date.timeIntervalSinceReferenceDate
                let phase = elapsed.truncatingRemainder(dividingBy: style.period) / style.period
                content.overlay {
                    style.highlight
                        .mask { content }
                        .mask { ShimmerBand(phase: phase, bandFraction: style.bandFraction) }
                        .allowsHitTesting(false)
                }
            }
        } else {
            content
        }
    }
}

/// A soft vertical band whose centre travels from just left of the view to just right of it.
struct ShimmerBand: View {
    var phase: Double
    var bandFraction: CGFloat

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let band = width * bandFraction
            let centerX = -band / 2 + (width + band) * CGFloat(phase)
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .white, location: 0.5),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: band, height: geometry.size.height)
            .position(x: centerX, y: geometry.size.height / 2)
        }
    }
}

public extension View {
    /// Sweeps a highlight across this view on the given cadence while `isActive` is true.
    func shimmer(_ style: ShimmerStyle = .standard, isActive: Bool = true) -> some View {
        modifier(Shimmer(style: style, isActive: isActive))
    }
}

/// Convenience: a label whose resting colour is `base` and which shimmers to `style.highlight`.
public struct ShimmerText: View {
    public var text: String
    public var font: Font
    public var base: Color
    public var style: ShimmerStyle
    public var isActive: Bool

    public init(_ text: String, font: Font, base: Color, style: ShimmerStyle = .standard, isActive: Bool = true) {
        self.text = text
        self.font = font
        self.base = base
        self.style = style
        self.isActive = isActive
    }

    public var body: some View {
        Text(text)
            .font(font)
            .foregroundStyle(base)
            .shimmer(style, isActive: isActive)
    }
}

#Preview("Shimmer on dark") {
    ZStack {
        Color.black.ignoresSafeArea()
        ShimmerText("slide to power off", font: .system(size: 20), base: .white.opacity(0.55))
    }
}
