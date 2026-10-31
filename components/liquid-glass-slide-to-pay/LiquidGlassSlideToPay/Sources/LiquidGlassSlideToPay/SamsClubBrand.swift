import SwiftUI
import CoreText

/// Colours from the Sam's Club Brand Playbook v1.5 (March 2026).
public enum SamsClubColor {
    /// Club Blue `#0A6CFF`. Leads the experience: the capsule tint and the header.
    public static let clubBlue = Color(red: 10 / 255, green: 108 / 255, blue: 255 / 255)
    /// Maverick Green `#00AC44`. Leads the secondary palette; the completed state.
    public static let maverickGreen = Color(red: 0 / 255, green: 172 / 255, blue: 68 / 255)
    /// Dark Green `#016F2C`, from the seasonal extension palette.
    public static let darkGreen = Color(red: 1 / 255, green: 111 / 255, blue: 44 / 255)
    /// Warm White `#F4F2E8`.
    public static let warmWhite = Color(red: 244 / 255, green: 242 / 255, blue: 232 / 255)
    /// Light Blue `#A6E0FF`. Accent; the shimmer highlight on a blue label.
    public static let lightBlue = Color(red: 166 / 255, green: 224 / 255, blue: 255 / 255)
    /// Warm Grey `#B9B3AB`.
    public static let warmGrey = Color(red: 185 / 255, green: 179 / 255, blue: 171 / 255)
    /// Yellow `#FFC720`.
    public static let yellow = Color(red: 255 / 255, green: 199 / 255, blue: 32 / 255)
    /// Red `#EC0015`.
    public static let red = Color(red: 236 / 255, green: 0 / 255, blue: 21 / 255)
}

/// Sam's Sans UI, the brand's UI typeface by Sharp Type.
///
/// Semibold is the heaviest UI weight. The playbook keeps Headline (Bold, Extrabold) for
/// large brand moments, so nothing in a control asks for more than Semibold.
///
/// The font files ship in this package's resources and are registered the first time a
/// `SamsSans` font is requested. If the host app already registers them through
/// `UIAppFonts`, the duplicate registration is ignored.
public enum SamsSans {
    public enum Weight: CaseIterable, Sendable {
        case light, regular, medium, semibold

        /// PostScript name, which is what `Font.custom` resolves.
        var postScriptName: String {
            switch self {
            case .light: "SamsSansUI-Light"
            case .regular: "SamsSansUI-Regular"
            case .medium: "SamsSansUI-Medium"
            case .semibold: "SamsSansUI-Semibold"
            }
        }
    }

    public enum MonoWeight: CaseIterable, Sendable {
        case regular, semibold

        var postScriptName: String {
            switch self {
            case .regular: "SamsSansMonoUI-Regular"
            case .semibold: "SamsSansMonoUI-Semibold"
            }
        }
    }

    /// Sam's Sans UI at `size`, scaling with Dynamic Type relative to `style`.
    public static func ui(_ size: CGFloat, weight: Weight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        registerFontsIfNeeded()
        return .custom(weight.postScriptName, size: size, relativeTo: style)
    }

    /// Sam's Sans Mono UI, for data tables and tabular alignment.
    public static func mono(_ size: CGFloat, weight: MonoWeight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        registerFontsIfNeeded()
        return .custom(weight.postScriptName, size: size, relativeTo: style)
    }

    /// Registers the bundled font files with Core Text. Safe to call repeatedly; it runs once.
    public static func registerFontsIfNeeded() {
        _ = registration
    }

    private static let registration: Void = {
        let urls = Bundle.module.urls(forResourcesWithExtension: "otf", subdirectory: nil) ?? []
        for url in urls {
            var error: Unmanaged<CFError>?
            // A false return usually means the face is already registered by the host app.
            // Either way the font resolves, and if it truly is missing `Font.custom` falls
            // back to the system font rather than failing.
            _ = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &error)
        }
    }()
}

/// The supplied brand marks, from the package asset catalog.
///
/// The wordmark switches to its inverse automatically in dark appearance. Playbook minimums:
/// 30 pt tall for the wordmark, 20 pt for the logomark. Never retype the wordmark in Sam's Sans.
public enum SamsClubMark {
    public static var logomark: Image { Image("SamsClubLogomark", bundle: .module) }
    public static var wordmark: Image { Image("SamsClubWordmark", bundle: .module) }
}
