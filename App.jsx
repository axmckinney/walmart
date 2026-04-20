const { useState } = React;

function DocsApp() {
  const [tab, setTab] = useState("Usage");

  return (
    <div style={{ background: "var(--ld-bg)", minHeight: "100vh", fontFamily: "var(--ld-font-sans)" }}>
      <TopNav active="Components" />
      <div style={{ maxWidth: 1440, margin: "0 auto", display: "flex" }}>
        <SideNav active="Button" />

        <main style={{ flex: 1, padding: "48px 48px 120px", maxWidth: 920 }}>
          {/* Breadcrumb */}
          <div style={{ fontSize: 13, color: "var(--ld-text-subtle)", marginBottom: 12 }}>
            Components <span style={{ margin: "0 6px" }}>/</span> Actions <span style={{ margin: "0 6px" }}>/</span> <span style={{ color: "var(--ld-text)" }}>Button</span>
          </div>

          {/* Title */}
          <h1 style={{ fontSize: 42, fontWeight: 700, letterSpacing: "-0.01em", margin: "0 0 12px", color: "var(--ld-text)" }}>Button</h1>
          <p style={{ fontSize: 18, lineHeight: "28px", color: "var(--ld-text-subtle)", margin: "0 0 24px", maxWidth: 680 }}>
            Buttons trigger actions. Use them for primary flows like submitting a form, adding to cart, or confirming a choice. Pair a primary action with at most one secondary action per view.
          </p>

          {/* Meta pills */}
          <div style={{ display: "flex", gap: 8, marginBottom: 32 }}>
            <span style={{ background: "var(--ld-green-10)", color: "var(--ld-text-positive-bold)", fontSize: 12, fontWeight: 700, padding: "4px 10px", borderRadius: 1000 }}>● Stable</span>
            <span style={{ background: "var(--ld-gray-5)", color: "var(--ld-text-subtle)", fontSize: 12, padding: "4px 10px", borderRadius: 1000 }}>React · Web · Mobile web</span>
            <span style={{ background: "var(--ld-gray-5)", color: "var(--ld-text-subtle)", fontSize: 12, padding: "4px 10px", borderRadius: 1000 }}>WCAG 2.2 AA</span>
          </div>

          {/* Tabs */}
          <Tabs tabs={["Usage", "Accessibility", "Props", "Guidelines"]} active={tab} onChange={setTab} />

          {tab === "Usage" && (
            <>
              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "24px 0 12px" }}>Variants</h2>
              <Preview>
                <LDButton variant="primary">Add to cart</LDButton>
                <LDButton variant="secondary">Continue shopping</LDButton>
                <LDButton variant="tertiary">Learn more</LDButton>
                <LDButton variant="destructive">Delete order</LDButton>
              </Preview>

              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "32px 0 12px" }}>Sizes</h2>
              <Preview>
                <LDButton size="sm">Small</LDButton>
                <LDButton size="md">Medium</LDButton>
                <LDButton size="lg">Large</LDButton>
              </Preview>

              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "32px 0 12px" }}>Disabled</h2>
              <Preview>
                <LDButton disabled>Disabled primary</LDButton>
                <LDButton variant="secondary" disabled>Disabled secondary</LDButton>
              </Preview>

              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "32px 0 12px" }}>Code</h2>
              <Code lang="tsx">{`import { Button } from "@walmart/living-design-react";

<Button variant="primary" size="md" onClick={handleAddToCart}>
  Add to cart
</Button>`}</Code>
            </>
          )}

          {tab === "Props" && (
            <PropTable rows={[
              { name: "variant", type: "'primary' | 'secondary' | 'tertiary' | 'destructive'", default: "'primary'", desc: "Visual weight of the button." },
              { name: "size", type: "'sm' | 'md' | 'lg'", default: "'md'", desc: "Target size." },
              { name: "disabled", type: "boolean", default: "false", desc: "Renders in disabled state, blocks pointer events." },
              { name: "isLoading", type: "boolean", default: "false", desc: "Shows a spinner and blocks clicks." },
              { name: "leading", type: "ReactNode", default: "—", desc: "Icon rendered before the label." },
              { name: "trailing", type: "ReactNode", default: "—", desc: "Icon rendered after the label." },
              { name: "onClick", type: "(e: MouseEvent) => void", default: "—", required: true, desc: "Called when the button is activated." },
            ]}/>
          )}

          {tab === "Accessibility" && (
            <div style={{ fontSize: 16, lineHeight: "26px", color: "var(--ld-text)" }}>
              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "24px 0 12px" }}>Keyboard</h2>
              <ul style={{ paddingLeft: 20, margin: 0 }}>
                <li><code style={{ fontFamily: "var(--ld-font-mono)", background: "var(--ld-gray-5)", padding: "2px 6px", borderRadius: 4 }}>Tab</code> — moves focus to the button.</li>
                <li><code style={{ fontFamily: "var(--ld-font-mono)", background: "var(--ld-gray-5)", padding: "2px 6px", borderRadius: 4 }}>Enter / Space</code> — activates the button.</li>
              </ul>
              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "24px 0 12px" }}>Screen readers</h2>
              <p>Use a descriptive label in the action voice — "Add to cart", not "Submit". Icon-only buttons must include an <code style={{ fontFamily: "var(--ld-font-mono)", background: "var(--ld-gray-5)", padding: "2px 6px", borderRadius: 4 }}>aria-label</code>.</p>
              <h2 style={{ fontSize: 24, fontWeight: 700, margin: "24px 0 12px" }}>Contrast</h2>
              <p>All button variants meet WCAG 2.2 AA (4.5:1) contrast against their intended background. Disabled buttons drop contrast intentionally — pair them with helper text explaining what's required.</p>
            </div>
          )}

          {tab === "Guidelines" && (
            <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16 }}>
              <div style={{ border: "1px solid var(--ld-gray-20)", borderRadius: 8, overflow: "hidden" }}>
                <div style={{ padding: 20, background: "var(--ld-bg)", display: "flex", justifyContent: "center", minHeight: 100, alignItems: "center" }}>
                  <LDButton variant="primary">Add to cart</LDButton>
                </div>
                <div style={{ background: "var(--ld-green-10)", color: "var(--ld-text-positive-bold)", padding: "12px 16px", fontWeight: 700, fontSize: 13 }}>✓ Do — action-oriented verb</div>
              </div>
              <div style={{ border: "1px solid var(--ld-gray-20)", borderRadius: 8, overflow: "hidden" }}>
                <div style={{ padding: 20, background: "var(--ld-bg)", display: "flex", justifyContent: "center", minHeight: 100, alignItems: "center" }}>
                  <LDButton variant="primary">Click here to submit</LDButton>
                </div>
                <div style={{ background: "var(--ld-red-10)", color: "var(--ld-text-negative-bold)", padding: "12px 16px", fontWeight: 700, fontSize: 13 }}>✗ Don't — generic, vague label</div>
              </div>
            </div>
          )}

          {/* Related */}
          <h2 style={{ fontSize: 24, fontWeight: 700, margin: "48px 0 12px" }}>Related</h2>
          <div style={{ display: "grid", gridTemplateColumns: "repeat(3, 1fr)", gap: 12 }}>
            {[{ n: "IconButton", d: "Icon-only variant for compact toolbars." }, { n: "Link", d: "Inline navigation that looks like a link." }, { n: "ButtonGroup", d: "Connected row of buttons." }].map(r => (
              <a key={r.n} href="#" style={{ display: "block", padding: 16, border: "1px solid var(--ld-gray-20)", borderRadius: 8, textDecoration: "none", color: "var(--ld-text)" }}>
                <div style={{ fontWeight: 700, marginBottom: 4 }}>{r.n} →</div>
                <div style={{ color: "var(--ld-text-subtle)", fontSize: 14 }}>{r.d}</div>
              </a>
            ))}
          </div>
        </main>

        {/* TOC right rail */}
        <aside style={{ width: 200, flex: "0 0 200px", padding: "48px 24px", fontFamily: "var(--ld-font-sans)", fontSize: 13 }}>
          <div style={{ fontSize: 11, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.06em", color: "var(--ld-text-subtlest)", marginBottom: 12, fontFamily: "var(--ld-font-mono)" }}>On this page</div>
          {[["Variants", true], ["Sizes"], ["Disabled"], ["Code"], ["Related"]].map(([t, active]) => (
            <a key={t} href="#" style={{ display: "block", padding: "4px 0", color: active ? "var(--ld-text-brand)" : "var(--ld-text-subtle)", textDecoration: "none", borderLeft: active ? "2px solid var(--ld-blue-100)" : "2px solid transparent", paddingLeft: 10, marginLeft: -12 }}>{t}</a>
          ))}
        </aside>
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<DocsApp />);
