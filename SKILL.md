---
name: living-design
description: Use this skill to generate well-branded Walmart interfaces and assets using Living Design — Walmart's global design system — for production work or throwaway prototypes, mocks, and slides. Contains essential design guidelines, color tokens, type system, Everyday Sans fonts, the full @livingdesign/icons set, brand marks, and React UI kit components for Walmart.com and the Living Design documentation site.
user-invocable: true
---

Read the `README.md` file within this skill, and explore the other available files.

If creating visual artifacts (slides, mocks, throwaway prototypes, etc), copy assets out and create static HTML files for the user to view. If working on production code, you can copy assets and read the rules here to become an expert in designing with this brand.

If the user invokes this skill without any other guidance, ask them what they want to build or design, ask some questions, and act as an expert designer who outputs HTML artifacts _or_ production code, depending on the need.

## What's in here

- `README.md` — brand context, content fundamentals, visual foundations, iconography, and an index of the folder.
- `colors_and_type.css` — primitive + semantic CSS variables for color, type, spacing, elevation, motion, plus semantic helper classes (`.ld-h1`, `.ld-body`, `.ld-magic-text`, etc).
- `fonts/` — Everyday Sans `.woff2` (Regular, Bold, Mono-Regular, Mono-Bold).
- `assets/icons/` — 130+ Living Design SVG icons, monochrome, `currentColor`-ready.
- `assets/walmart-logo.svg`, `walmart-spark.svg`, `living-design-logo.svg` — brand marks.
- `preview/` — design-system review cards (swatches, type specimens, token visualizations, component specimens).
- `ui_kits/walmart_com/` — customer-web homepage recreation (Header, HeroStrip, CategoryTiles, ProductCard, Shelf, CartDrawer).
- `ui_kits/living_design_docs/` — Living Design documentation site recreation (TopNav, SideNav, Tabs, Code, PropTable, Preview).

## Rules of thumb

- **Always** include `colors_and_type.css` and reference tokens by variable, not raw hex.
- **Walmart Blue** (`--ld-blue-100`) for interactive / primary. **Spark Yellow** (`--ld-spark-100`) for brand accents, logo, Rollback tags — never a button fill.
- **Type** is Everyday Sans, Regular (400) or Bold (700). No italics.
- **Buttons** are full pill shape (`radius-round`), bold label, sentence-case verb.
- **Copy** is second person, active voice, sentence case, savings-forward. No emoji.
- **Icons** come from `assets/icons/`. Copy the SVG, don't redraw. If missing, sub the closest Lucide equivalent and flag it.
- **Cards** are white with 8px radius and a single 1px gray-20 border OR `elevation-100` — never both.
