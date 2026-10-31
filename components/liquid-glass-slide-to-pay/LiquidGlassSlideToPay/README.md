# LiquidGlassSlideToPay

SwiftUI components for the Sam's Club "Slide to pay" control in Liquid Glass. The track stays solid Club Blue, as in production; the glass lives on the handle and the label. iOS 17 and later; on iOS 26 and later the glass surfaces use `glassEffect`, on iOS 17 and 18 they fall back to a system material with a rim light so layout and behavior stay identical.

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
    @State private var phase: SlideToPayPhase = .idle

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView { /* checkout content, with bottom padding to scroll under the tray */ }
            CheckoutPayTray(total: "$148.45", itemCount: 4, phase: $phase) {
                // The slide completed and the control is showing "Placing your order".
                Task {
                    do {
                        try await payments.placeOrder()
                        phase = .complete      // green "Order placed"
                    } catch {
                        phase = .idle          // knob springs back; show your error
                    }
                }
            }
            .padding(12)
        }
    }
}
```

Or the control on its own:

```swift
SlideToPayControl(amountDescription: "$148.45", phase: $phase) {
    // start the payment, then set phase
}
```

`phase` is the whole contract. The control moves itself to `.processing` when the slide completes and calls `onSlide`; you move it to `.complete` or back to `.idle`. Setting `.idle` at any time resets the control with an animation.

`SlideToPayDemo` is a full checkout screen with cards, header, and a Reset button, for previews and design review.

## What is in it

| File | Contents |
| --- | --- |
| `SlideToPayControl.swift` | `SlideToPayPhase` and the control: solid Club Blue track, clear glass knob, shimmering label, drag with velocity stretch, spring back, processing ring, completion morph, haptics, VoiceOver. |
| `Shimmer.swift` | `.shimmer()` modifier and `ShimmerText`: the iOS 27 slide-control label treatment. |
| `LiquidGlassSurface.swift` | `.liquidGlass(_:in:interactive:)`: `glassEffect` on iOS 26, material fallback before. |
| `CheckoutPayTray.swift` | The tray (total, control, legal line) and `SlideToPayDemo`. |
| `SamsClubBrand.swift` | `SamsClubColor` from the playbook, `SamsSans` fonts with self-registration, `SamsClubMark` images. |
| `Resources/` | Sam's Sans UI and Mono UI OTFs, asset catalog with the logomark and the wordmark (inverse in dark). |

## Behavior

**Shimmer.** The label, not the capsule, carries the shimmer, matching the iOS 27 slide controls. A soft band about a third of the label's width crosses it once every 1.6 s, starting and ending off the text. The label rests at 62% white and brightens to white. The shimmer pauses while the knob is held and stops once the payment completes. Reduce Motion renders the label plainly.

**Materials.** The track is a solid Club Blue capsule: no gradient, no material. The knob is `.clear` glass, so on device it refracts the label as it passes, and the label is translucent white that the shimmer brightens. The tray is `.regular` glass with a 34 pt continuous corner. Glass surfaces are `.interactive()` so they respond to touch the way system glass does.

**Drag.** The knob follows the finger. Its horizontal stretch comes from drag velocity (up to 26%), relaxing 90 ms after the finger stops. A lighter capsule fills the track behind the knob. Soft impact haptics tick at each quarter. Releasing below 88% springs back with a small overshoot.

**Processing.** Past 88%, the knob snaps to the end and parks there. Its chevron shrinks away and a 2.5 pt progress ring in Club Blue turns inside the glass, once every 0.9 s. The label changes to "Placing your order" and keeps shimmering, slightly faster (1.1 s) so it reads as activity. A start haptic fires and `onSlide` is called. The state holds for at least `minimumProcessingDuration` (0.6 s) even if the host confirms instantly, so it never flashes.

**Completion.** When the host sets `.complete`, the knob swells leftward to fill the capsule and dissolves while the fill turns Maverick Green and "Order placed" fades in with a checkmark. A success haptic fires. Setting `.idle` instead, for a declined payment, springs the knob back to the start.

**Accessibility.** The control is one adjustable element. Swipe up or down moves the knob in 10% steps, reaching the end starts the payment, and a custom "Pay" action starts it directly. The label reads "Slide to pay, $148.45" and the value reports progress, "Placing your order", or "Order placed"; each phase change is also announced. Dynamic Type scales every font through `relativeTo:`.

## Brand

- Type is Sam's Sans UI: Semibold for the label, total, and headings; Medium for chips; Regular for body. Semibold is the heaviest UI weight, so nothing here asks for Bold.
- Club Blue `#0A6CFF` fills the track. Maverick Green `#00AC44` fills it once the payment completes.
- The logomark appears on the "Delivery from club" band at 29 pt (playbook minimum 20). The wordmark asset is included at the playbook's 30 pt minimum in mind and swaps to its inverse in dark appearance.
