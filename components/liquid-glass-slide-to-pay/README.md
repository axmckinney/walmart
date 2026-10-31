# Slide to pay · Liquid Glass

The Sam's Club checkout "Slide to pay" control, rebuilt as layered glass in the style of iOS Liquid Glass. Two implementations share one design:

- **`LiquidGlassSlideToPay/`**, a Swift package of SwiftUI components. This is the production direction: real `glassEffect` on iOS 26 and later with a material fallback for iOS 17 and 18, haptics, VoiceOver, Dynamic Type, Reduce Motion. See its README.
- **`index.html`**, a browser prototype for review without Xcode. Open it directly; fonts, marks, and thumbnails are inlined. The source assets live in `../../assets/sams-club/`.

## What changed from production

| Production control | Liquid Glass version |
| --- | --- |
| Flat white footer bar | Floating glass tray, inset 12 px, `blur 20 · saturate 170% · white 60%`, 34 px radius |
| Solid `#0a6cff` capsule | Unchanged: solid Club Blue, flat, no gradient. Glass is reserved for the handle and the label |
| Solid white knob, blue chevron | Clear lens knob. Chrome and Edge refract the backdrop through an SVG displacement map; other browsers get a gradient lens ring |
| Sheen sweeps the blue capsule every 2.6 s | The capsule stays still. The label shimmers instead, as on the iOS 27 slide controls: a soft band crosses the text every 1.6 s, brightening it from 62% white to white (Club Blue to Light Blue on the clear variant). Pauses while the knob is held |
| No press feedback | Capsule scales to 1.015 and the knob brightens on press |
| Knob follows finger 1:1 | Knob trails slightly and stretches with velocity, a lighter liquid fill follows behind; early release springs back |
| Spinner, then confirmation | Processing: knob parks at the end, its chevron becomes a progress ring, label reads "Placing your order" and keeps shimmering. Completion: knob swells leftward into the capsule and dissolves, the fill turns Maverick Green `#00AC44`, label reads "Order placed" |

## Interaction

- Drag the knob past 88% and release to pay. Release earlier and it springs back. The prototype simulates a 1.6 s payment round trip before confirming.
- Keyboard: focus the knob, arrow keys move it in 10% steps, Home and End jump, End pays.
- "Reset" appears in the header after completion. The spec column also has a Reset button.
- `prefers-reduced-motion` disables the shimmer, the stretch and the spring.

## Web prototype structure

Everything lives in `index.html`:

- `.glass-tray` is the floating sheet.
- `.lg-slide` is the capsule, a solid fill driven by `--cap`. The `is-done` class switches it to Maverick Green.
- `.lg-label-text::after` is the shimmer: the label text repeated as a transparent copy with a moving gradient clipped to it.
- `.lg-knob` is the lens. The `lens-on` class, added only in Chromium, switches its `backdrop-filter` to the `#lg-lens` SVG filter whose displacement map is generated on a canvas at load.
- The `<script>` block at the bottom owns the pointer, spring and completion logic.

## Brand

- Type is Sam's Sans UI: Semibold (600) for the label, total and headings, Medium (500) for chips and choice buttons, Regular (400) for body. Sam's Sans Mono UI sets the token values in the spec column. Semibold is the heaviest UI weight, so nothing on the page asks for 700.
- Club Blue `#0A6CFF` is the solid capsule fill and the header. Maverick Green `#00AC44` is the completion fill. The page ground uses Warm White `#F4F2E8` with Warm Grey derived lines; the dark theme reuses the same neutrals inverted.
- The logomark sits on the "Delivery from club" band at 28 px (minimum is 20). The wordmark heads the spec column at 30 px (the minimum), swapping to the inverse SVG in dark mode through a CSS token.

## Notes

- The name and address on the delivery card are placeholders, not the ones in the source screenshot.
- The knob chevron is a stroked 2.6 px path to match the production weight.
