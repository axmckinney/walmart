# LiquidGlassSlideToPay

SwiftUI components for the Sam's Club "Slide to pay" control in Liquid Glass. iOS 17 and later; on iOS 26 and later the surfaces are real Liquid Glass through `glassEffect`, on iOS 17 and 18 they fall back to a system material with a rim light so layout and behavior stay identical.

The package was written without access to Xcode in this session, so it has not been compiled. Open it in Xcode 26 and run the previews first; anything the compiler flags should be small.

## Add it

Xcode: File, Add Package Dependencies, then point at this folder (or the repo URL with the path `components/liquid-glass-slide-to-pay/LiquidGlassSlideToPay`). Or in `Package.swift`:

```swift
.package(path: "../components/liquid-glass-slide-to-pay/LiquidGlassSlideToPay")
```

Fonts and the two brand marks ship inside the package. Sam's Sans UI registers itself the first time a `SamsSans` font is requested, so no `UIAppFonts` entry is needed.

## Use it

```swift
import LiquidGlassSlideToPay

struct Checkout: View {
    @State private var paid = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView { /* checkout content, with bottom padding to scroll under the tray */ }
            CheckoutPayTray(total: "$148.45", itemCount: 4, isComplete: $paid) {
                // place the order
            }
            .padding(12)
        }
    }
}
```

Or the control on its own:

```swift
SlideToPayControl(amountDescription: "$148.45", variant: .tinted, isComplete: $paid) {
    // place the order
}
```

Set `isComplete` back to `false` to reset the control; it animates back to idle.

`SlideToPayDemo` is a full checkout screen with cards, header, and a Reset button, for previews and design review.

## What is in it

| File | Contents |
| --- | --- |
| `SlideToPayControl.swift` | The control: tinted glass track, clear glass knob, drag with velocity stretch, spring back, completion morph, haptics, VoiceOver. |
| `Shimmer.swift` | `.shimmer()` modifier and `ShimmerText`: the iOS 27 slide-control label treatment. |
| `LiquidGlassSurface.swift` | `.liquidGlass(_:in:interactive:)`: `glassEffect` on iOS 26, material fallback before. |
| `CheckoutPayTray.swift` | The tray (total, control, legal line) and `SlideToPayDemo`. |
| `SamsClubBrand.swift` | `SamsClubColor` from the playbook, `SamsSans` fonts with self-registration, `SamsClubMark` images. |
| `Resources/` | Sam's Sans UI and Mono UI OTFs, asset catalog with the logomark and the wordmark (inverse in dark). |

## Behavior

**Shimmer.** The label, not the capsule, carries the shimmer, matching the iOS 27 slide controls. A soft band about a third of the label's width crosses it once every 1.6 s, starting and ending off the text. On the tinted variant the label rests at 62% white and brightens to white; on the clear variant it rests at Club Blue and brightens to Light Blue. The shimmer pauses while the knob is held and stops once the payment completes. Reduce Motion renders the label plainly.

**Materials.** The track is `.regular` glass tinted Club Blue (`.regular` untinted on the clear variant). The knob is `.clear` glass, so on device it refracts the label as it passes. The tray is `.regular` glass with a 34 pt continuous corner. Everything is `.interactive()` so it responds to touch the way system glass does.

**Drag.** The knob follows the finger. Its horizontal stretch comes from drag velocity (up to 26%), relaxing 90 ms after the finger stops. A lighter capsule fills the track behind the knob. Soft impact haptics tick at each quarter. Releasing below 88% springs back with a small overshoot.

**Completion.** Past 88%, the knob snaps to the end, then swells leftward to fill the capsule and dissolves while the tint turns Maverick Green and "Order placed" fades in with a checkmark. A success haptic fires and `onComplete` is called.

**Accessibility.** The control is one adjustable element. Swipe up or down moves the knob in 10% steps, reaching the end completes, and a custom "Pay" action completes directly. The label reads "Slide to pay, $148.45" and the value reports progress or "Order placed". Dynamic Type scales every font through `relativeTo:`.

## Brand

- Type is Sam's Sans UI: Semibold for the label, total, and headings; Medium for chips; Regular for body. Semibold is the heaviest UI weight, so nothing here asks for Bold.
- Club Blue `#0A6CFF` tints the track. Maverick Green `#00AC44` is the completed tint. Light Blue `#A6E0FF` is the shimmer highlight on a blue label.
- The logomark appears on the "Delivery from club" band at 29 pt (playbook minimum 20). The wordmark asset is included at the playbook's 30 pt minimum in mind and swaps to its inverse in dark appearance.
