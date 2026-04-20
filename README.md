# Living Design

**Walmart's global design system** for omni-channel experiences across the enterprise — web, mobile, associate tools, and in-store. This skill packages the foundations (color, type, space, motion, elevation), a Walmart-scale icon library, and two UI kit recreations so Claude can produce well-branded Walmart artifacts and prototypes.

## Sources

Provided as read-only mounted folders during creation:

- **`tokens-main 2/`** — `@livingdesign/tokens`, the primitive + semantic design token set (colors, type, space, elevation, motion, breakpoints). Published as CSS variables, JS, Less, and Sass in `dist/`.
- **`icons-main/`** — `@livingdesign/icons`. 130+ default-size line + solid icons as SVG and React components, plus a mega/feature-sized variant.
- **`react-main/`** — `@walmart/living-design-react`, Walmart's React component library built on the tokens (Button, Input, Radio, Checkbox, Switch, Alert, Modal, etc.).
- **`everyday-sans-main/`** — `@walmart/everyday-sans` web font package. Regular + Bold for display and mono; bundled here as `.woff2`.
- **Uploaded fonts** — `uploads/EverydaySansUI-Bold.otf`, `uploads/EverydaySansUI-Regular.otf` (kept as originals; the web-ready `.woff2` files are what this skill actually uses).

Reader does **not** need access to these — everything this skill needs has been extracted into this project.

---

## Company & product context

Walmart is a global omni-channel retailer. Living Design serves every digital surface Walmart ships, which span roughly three product families:

1. **Customer commerce** — `walmart.com`, the Walmart iOS/Android app, and sub-brands (Walmart+, Walmart Business, Sam's Club uses its own system). Core shopper flows: search, product detail, cart, checkout, order tracking.
2. **Associate & operations tools** — apps used by store and fulfillment associates (Me@Walmart, Store Assist, etc.). Same tokens, denser layouts, more data-heavy.
3. **Documentation & internal sites** — the Living Design site itself and internal engineering portals — calm, text-forward, Walmart-blue accented.

The Living Design team treats the system as a **living** one (hence the name) — tokens and components ship continuously to `livingdesign.walmart.com` and the npm packages under `@livingdesign/*` and `@walmart/*`.

---

## Content fundamentals

Walmart copy is pragmatic and plain-spoken — it tells a busy shopper exactly what's next.

**Voice**
- **Second person, active voice.** "Add to cart", "See how it works", "Get it by tomorrow." Never "Users can add…".
- **Savings-forward.** Copy leads with price, then value, then feature. "Save $20 on…", "Rollback", "Was $29, now $19."
- **Trusty, not cute.** No winking, no puns. A headline like "Deals you'll love" is the upper limit of warmth.
- **Confident imperatives.** Buttons are verbs: "Add to cart", "Check out", "Continue", "Track order." No "Click here", no "Please".
- **No emoji.** Walmart surfaces do not use emoji as UI. Icons come from `@livingdesign/icons`.

**Casing**
- **Sentence case everywhere** — buttons, headers, page titles, nav items. "Grocery & essentials", not "Grocery & Essentials". Exception: proper nouns (Walmart+, Rollback, Spark Cash).
- Prices are `$12.98`, savings are `Save $3.00`, comparisons are `Was $15.00`.

**Microcopy patterns**
- Delivery promises: "Get it by Thu, Oct 24", "Free same-day delivery", "Pickup today".
- Status: "In 18 carts", "Only 3 left!", "Sold and shipped by Walmart.com".
- Errors: direct, solution-first. "Enter a valid ZIP code", not "The ZIP code you entered is invalid."
- Marketing badges: short, all-caps or sentence-case tag style — "Rollback", "Clearance", "Best seller", "Popular pick".

**Tone examples**
- Hero: *"Save money. Live better."* (brand line — use sparingly, only in brand-level surfaces)
- Promo: *"Rollback on fresh essentials — get them in today."*
- Empty state: *"No items yet. Add things to your cart to see them here."*
- Success: *"Order placed. We'll text you when it ships."*

---

## Visual foundations

**Color**
- **Walmart Blue** (`--ld-blue-100` / `#0053E2`) is the primary brand and interactive color — buttons, links, focused states, the logo's wordmark.
- **Spark Yellow** (`--ld-spark-100` / `#FFC220`) is the logo/accent — never a button fill. It appears on the Spark mark, highlight badges (Rollback), and occasional illustrative accents.
- **Gray scale** runs 5→180 (50 shades-ish; 18 stops). `gray-160` (`#2E2F32`) is the default text color; `gray-5` is the app canvas tint. Walmart does NOT use pure black for text.
- **Status colors** — green (`#2A8703`), red (`#EA1100`), spark yellow for warning, blue for info. Always paired with a `-subtle` tint for backgrounds and a `-bold` shade for text on those tints.
- **Magic gradient** — blue→cyan linear gradient reserved for AI/Sparky features. Used as a text fill, button border, or thin accent — never as a page background.

**Type** — Everyday Sans (Walmart's proprietary sans), two weights: **Regular 400** and **Bold 700**. No italics, no extra weights. Mono variant for numeric tables and code. Display sizes step up at the `large` breakpoint (900px). Letter-spacing tightens slightly on display headings (`-0.01em`), otherwise normal.

**Spacing** — geometric scale rooted at 4px: `space-25` (2), `50` (4), `100` (8), `150` (12), `200` (16), `300` (24), `400` (32), up to `1000` (80). All component padding and gap values come from this scale.

**Borders & radii** — radii use the same step system: `25` (2px) for inputs, `100` (8px) for cards/buttons, `200` (16px) for modals and large cards, and `round` (1000px) for pills and avatars. Default border is 1px, selected/error states step up to 2px.

**Backgrounds** — mostly flat: white canvas (`--ld-bg`) with gray-5 (`--ld-bg-subtle`) shelves behind cards. Photography is full-bleed, bright, product-first — no duotones, no heavy filters, no grain. The Magic gradient is the only gradient in regular use.

**Elevation** — three soft, warm shadows (`elevation-100/200/300`). They stack a darker downward shadow with a lighter upward one, giving a rounded "floating card" feel rather than a hard drop shadow. Cards almost always use `elevation-100`; sticky headers use `200`; popovers and modals use `300`.

**Motion** — tokenized durations (`100`–`700`ms) and four easings (`in`, `out`, `in-out`, `linear`). The default transition is `200ms` `ease-out` for hover/focus and `300ms` `ease-in-out` for layout. Animations are crisp and short — no bounces, no parallax, no elastic springs.

**Hover / focus / pressed**
- **Hover**: surface shifts one step darker (`fill` → `fill-hovered` using `gray-10`), text color unchanged. Blue primary buttons darken from `blue-100` to `blue-110`.
- **Pressed**: one more step darker (`gray-20` / `blue-130`) and shadow flattens.
- **Focus**: 2px `blue-100` outline offset by 2px — always visible, never suppressed.
- **Disabled**: content drops to `gray-50`, surface to `gray-5`, no pointer. Never opacity-based.

**Transparency & blur** — rare. Used only for (a) modal scrims (black at 50% opacity), (b) the search suggestions dropdown shadow, and (c) the Sparky AI panel's slight backdrop blur. Never on cards or buttons.

**Cards** — white fill, `radius-100` (8px) corners on mobile, `radius-200` (16px) on desktop product cards. Either `elevation-100` or a single `1px` `gray-20` border — never both. Padding: `space-200` (16px) interior on mobile, `space-300` (24px) on desktop.

**Layout rules**
- Content max-width on desktop is 1440px with `space-400` (32px) side gutters.
- Mobile gutter is `space-200` (16px).
- Grid: 12-column on desktop, 4-column on mobile, with `space-200` gutters.
- Bottom nav on mobile (56px), top nav + category strip on desktop.

**Imagery tone** — bright, neutral white background for product photos; real photography of families, food, and stores for lifestyle shots. No illustration style is common — when illustrations appear they are flat, friendly, and use Walmart's palette directly (blue, spark, green).

---

## Iconography

Walmart uses its own `@livingdesign/icons` set, all copied into `assets/icons/` as SVGs.

- **Style**: 24×24 default, 1.75px stroke, rounded linecaps, square-ish silhouettes. Each concept has a line form (`Heart.svg`) and, for many, a filled form (`HeartFill.svg`) used for selected/active states.
- **Format**: all icons are monochrome SVG — no embedded fills. Color them via `color` on an `<svg>` wrapper or inline `fill="currentColor"` (most exported files already use that).
- **Coverage**: ~130 icons spanning commerce (Cart, Tag, Receipt, Wallet, Truck, Returns), UI (ChevronRight, Close, Menu, More, Search), status (CheckCircle, ExclamationCircle, InfoCircle), account (User, UserCircle, UserPlus), and Walmart-specific motifs (Magic for AI, Facility for stores, Barcode, QrCode, Spark via a separate wordmark).
- **Spark/brand marks**: kept separately — `assets/walmart-logo.svg`, `assets/walmart-spark.svg`, `assets/living-design-logo.svg` (the last two are mark recreations; confirm with a brand-approved asset before using in production).
- **Emoji / Unicode**: not used as UI. Don't substitute.
- **Missing sizes**: Living Design publishes a "mega" (feature-sized, 48px) variant too. If something needs 48px, scale the default SVG up — it reads cleanly at 2× since stroke weights are defined in relative units.

Usage: prefer `<img src="assets/icons/Heart.svg" alt="Favorite">` for static, or inline the SVG and set `fill="currentColor"` when you need to tint via CSS.

---

## Substitutions & caveats

- **Everyday Sans** — the web `.woff2` files (`everyday-sans-main/`) were available; both UI OTFs uploaded are the originals. Coverage is Regular + Bold only, Latin-1.
- **Spark + Walmart wordmark SVGs** — recreated from Walmart's public brand geometry, not extracted from a brand-approved asset repo. Verify against the official style guide before shipping.
- **Mobile / associate-tool UI kits** — not generated; the React source and Figma library for those surfaces wasn't mounted. This skill ships `walmart_com` (customer web) and `living_design_docs` (Living Design documentation site) UI kits only.

---

## Index

```
├── README.md                 ← you are here
├── SKILL.md                  ← cross-agent skill manifest
├── colors_and_type.css       ← CSS variables + semantic classes
├── fonts/                    ← Everyday Sans .woff2 (Regular, Bold, Mono)
├── assets/
│   ├── icons/                ← 130+ Living Design SVG icons
│   ├── walmart-logo.svg
│   ├── walmart-spark.svg
│   └── living-design-logo.svg
├── preview/                  ← Design System review cards (one per token / component)
├── ui_kits/
│   ├── walmart_com/          ← customer web UI kit
│   │   ├── index.html        ← homepage click-thru
│   │   ├── Header.jsx        ← top nav + search + cart
│   │   ├── Shop.jsx          ← HeroStrip, CategoryTiles, ProductCard, Shelf, CartDrawer
│   │   └── App.jsx           ← wired demo
│   └── living_design_docs/   ← docs-site UI kit
│       ├── index.html        ← component detail page
│       ├── DocsKit.jsx       ← TopNav, SideNav, Tabs, Code, PropTable, Preview, LDButton
│       └── App.jsx           ← Button documentation page
└── uploads/                  ← original uploaded OTF fonts
```
