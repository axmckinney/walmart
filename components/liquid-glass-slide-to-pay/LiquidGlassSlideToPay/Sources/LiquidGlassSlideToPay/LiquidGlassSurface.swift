import SwiftUI

/// The material a surface is rendered with.
public enum LiquidGlassMaterial: Sendable {
    /// Regular glass carrying a colour. Content behind it reads as colour, not detail.
    case tinted(Color)
    /// Regular glass with no tint. The tray and small controls on it.
    case regular
    /// Clear glass: the lens. Refracts what sits behind it. The knob.
    case clear
}

/// Applies Liquid Glass on iOS 26 and later, and a layered material with a rim light before that.
///
/// Both paths keep the same shape, so layout and hit testing do not change between OS versions.
struct LiquidGlassSurface<S: InsettableShape>: ViewModifier {
    var material: LiquidGlassMaterial
    var shape: S
    var interactive: Bool

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(glass, in: shape)
        } else {
            content.background { fallback }
        }
    }

    @available(iOS 26.0, *)
    private var glass: Glass {
        let base: Glass
        switch material {
        case .tinted(let color):
            base = .regular.tint(color)
        case .regular:
            base = .regular
        case .clear:
            base = .clear
        }
        return interactive ? base.interactive() : base
    }

    /// iOS 17 and 18: system material, a tint wash, and a top-left rim light.
    @ViewBuilder
    private var fallback: some View {
        ZStack {
            switch material {
            case .tinted(let color):
                shape.fill(.ultraThinMaterial)
                shape.fill(color.opacity(0.78))
                shape.fill(
                    LinearGradient(
                        colors: [.white.opacity(0.18), .clear, .black.opacity(0.12)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            case .regular:
                shape.fill(.regularMaterial)
            case .clear:
                shape.fill(.ultraThinMaterial)
                shape.fill(.white.opacity(0.55))
                shape.fill(
                    RadialGradient(
                        colors: [.clear, .clear, .black.opacity(0.08), .white.opacity(0.45)],
                        center: .center,
                        startRadius: 0,
                        endRadius: 32
                    )
                )
            }
            shape.strokeBorder(
                LinearGradient(
                    colors: [.white.opacity(0.85), .white.opacity(0.12), .white.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
        }
        .shadow(color: .black.opacity(0.18), radius: 10, y: 6)
    }
}

public extension View {
    /// Renders this view on Liquid Glass (iOS 26) or a material stand-in (earlier), clipped to `shape`.
    func liquidGlass<S: InsettableShape>(
        _ material: LiquidGlassMaterial = .regular,
        in shape: S = Capsule(),
        interactive: Bool = false
    ) -> some View {
        modifier(LiquidGlassSurface(material: material, shape: shape, interactive: interactive))
    }
}
