# Slide to pay · Liquid Glass

An interactive prototype of the Sam's Club checkout "Slide to pay" control, rebuilt as layered glass in the style of iOS Liquid Glass. Open `index.html` in a browser; no build step or server is needed. Fonts (Everyday Sans) and the four product thumbnails are inlined.

## What changed from production

| Production control | Liquid Glass version |
| --- | --- |
| Flat white footer bar | Floating glass tray, inset 12 px, `blur 20 · saturate 170% · white 60%`, 34 px radius |
| Solid `#0a6cff` capsule | Sam's blue as a tint (82→74%) over `blur 14 · saturate 180%`, so content shifts the colour as it scrolls underneath |
| Solid white knob, blue chevron | Clear lens knob. Chrome and Edge refract the backdrop through an SVG displacement map; other browsers get a gradient lens ring |
| Sheen sweep every 2.6 s | Same cadence, rendered as a soft caustic in screen blend. Pauses while the knob is held |
| No press feedback | Capsule scales to 1.015 and the knob brightens on press |
| Knob follows finger 1:1 | Knob trails slightly and stretches with velocity, a lighter liquid fill follows behind; early release springs back |
| Flat completion | Knob swells leftward into the capsule and dissolves, tint turns positive green, label reads "Order placed" |

## Interaction

- Drag the knob past 88% and release to complete. Release earlier and it springs back.
- Keyboard: focus the knob, arrow keys move it in 10% steps, Home and End jump, End completes.
- "Reset" appears in the header after completion. The spec column also has Reset and a Tinted / Clear material toggle.
- `prefers-reduced-motion` disables the sheen, the stretch and the spring.

## Structure

Everything lives in `index.html`:

- `.glass-tray` is the floating sheet.
- `.lg-slide` is the capsule. Material is driven by five custom properties (`--cap-a`, `--cap-b`, `--label`, `--kbg`, `--kfg`), and the `is-clear` class swaps them for the clear variant.
- `.lg-knob` is the lens. The `lens-on` class, added only in Chromium, switches its `backdrop-filter` to the `#lg-lens` SVG filter whose displacement map is generated on a canvas at load.
- The `<script>` block at the bottom owns the pointer, spring and completion logic.

## Notes

- The name and address on the delivery card are placeholders, not the ones in the source screenshot.
- The knob chevron is a stroked 2.6 px path to match the production weight rather than the thinner Living Design `ChevronRight` glyph.
