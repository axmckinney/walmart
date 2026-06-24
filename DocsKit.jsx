/* Living Design docs site UI kit — cosmetic */
const { useState } = React;

/* ---------------- TopNav ---------------- */
function TopNav({ active = "Components" }) {
  const items = ["Get started", "Foundations", "Components", "Patterns", "Icons", "Tokens"];
  return (
    <header style={ldStyles.nav}>
      <div style={ldStyles.navInner}>
        <a href="#" style={ldStyles.brand}>
          <span style={ldStyles.logoMark}/>
          <span style={ldStyles.brandText}>Living Design</span>
          <span style={ldStyles.version}>v25.10</span>
        </a>
        <nav style={ldStyles.navLinks}>
          {items.map(it => (
            <a key={it} href="#" style={{ ...ldStyles.navLink, ...(it === active ? ldStyles.navLinkActive : {}) }}>{it}</a>
          ))}
        </nav>
        <div style={ldStyles.navRight}>
          <div style={ldStyles.search}>
            <img src="../../assets/icons/Search.svg" width={16} height={16} style={{ opacity: 0.6 }}/>
            <span style={{ color: "var(--ld-text-subtle)", fontSize: 14 }}>Search docs</span>
            <span style={ldStyles.kbd}>⌘K</span>
          </div>
          <a href="#" style={ldStyles.ghLink}>GitHub ↗</a>
        </div>
      </div>
    </header>
  );
}

/* ---------------- SideNav ---------------- */
function SideNav({ active = "Button" }) {
  const groups = [
    { h: "Overview", items: ["Introduction", "Installation", "Changelog"] },
    { h: "Actions", items: ["Button", "IconButton", "Link"] },
    { h: "Inputs", items: ["Checkbox", "Input", "Radio", "Select", "Switch", "Textarea"] },
    { h: "Feedback", items: ["Alert", "Badge", "Modal", "Spinner", "Toast"] },
    { h: "Navigation", items: ["Breadcrumb", "Pagination", "Pill", "Tabs"] },
    { h: "Surfaces", items: ["Card", "Divider", "List"] },
  ];
  return (
    <aside style={ldStyles.side}>
      {groups.map(g => (
        <div key={g.h} style={{ marginBottom: 24 }}>
          <div style={ldStyles.sideH}>{g.h}</div>
          {g.items.map(it => (
            <a key={it} href="#" style={{ ...ldStyles.sideItem, ...(it === active ? ldStyles.sideItemActive : {}) }}>{it}</a>
          ))}
        </div>
      ))}
    </aside>
  );
}

/* ---------------- Tabs ---------------- */
function Tabs({ tabs, active, onChange }) {
  return (
    <div style={{ borderBottom: "1px solid var(--ld-gray-20)", display: "flex", gap: 4, marginBottom: 20 }}>
      {tabs.map(t => (
        <button key={t} onClick={() => onChange(t)} style={{
          background: "transparent", border: "none", padding: "12px 16px", fontSize: 14, fontWeight: 700, cursor: "pointer", fontFamily: "var(--ld-font-sans)",
          borderBottom: t === active ? "2px solid var(--ld-blue-100)" : "2px solid transparent",
          color: t === active ? "var(--ld-text)" : "var(--ld-text-subtle)",
          marginBottom: -1,
        }}>{t}</button>
      ))}
    </div>
  );
}

/* ---------------- Code block ---------------- */
function Code({ children, lang = "tsx" }) {
  return (
    <div style={{ background: "var(--ld-gray-170)", color: "#e3e4e5", padding: 20, borderRadius: 8, fontFamily: "var(--ld-font-mono)", fontSize: 13, lineHeight: "20px", overflow: "auto" }}>
      <div style={{ color: "var(--ld-gray-70)", fontSize: 11, marginBottom: 10, textTransform: "uppercase", letterSpacing: "0.04em" }}>{lang}</div>
      <pre style={{ margin: 0, whiteSpace: "pre" }}>{children}</pre>
    </div>
  );
}

/* ---------------- Prop table ---------------- */
function PropTable({ rows }) {
  return (
    <table style={{ width: "100%", borderCollapse: "collapse", fontFamily: "var(--ld-font-sans)", fontSize: 14 }}>
      <thead>
        <tr style={{ borderBottom: "1px solid var(--ld-gray-30)" }}>
          {["Prop", "Type", "Default", "Description"].map(h => <th key={h} style={{ textAlign: "left", padding: "10px 12px", fontWeight: 700, fontSize: 13 }}>{h}</th>)}
        </tr>
      </thead>
      <tbody>
        {rows.map(r => (
          <tr key={r.name} style={{ borderBottom: "1px solid var(--ld-gray-10)" }}>
            <td style={{ padding: "10px 12px", fontFamily: "var(--ld-font-mono)", fontSize: 13, color: "var(--ld-text)" }}>{r.name}{r.required && <span style={{ color: "var(--ld-red-100)" }}> *</span>}</td>
            <td style={{ padding: "10px 12px", fontFamily: "var(--ld-font-mono)", fontSize: 12, color: "var(--ld-text-subtle)" }}>{r.type}</td>
            <td style={{ padding: "10px 12px", fontFamily: "var(--ld-font-mono)", fontSize: 12, color: "var(--ld-text-subtle)" }}>{r.default || "—"}</td>
            <td style={{ padding: "10px 12px", color: "var(--ld-text)" }}>{r.desc}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

/* ---------------- Button example ---------------- */
function LDButton({ variant = "primary", size = "md", children, disabled, onClick }) {
  const base = { fontFamily: "var(--ld-font-sans)", fontWeight: 700, border: "none", cursor: disabled ? "not-allowed" : "pointer", borderRadius: 1000, transition: "background 200ms var(--ld-ease-out)" };
  const sizes = { sm: { padding: "8px 14px", fontSize: 14 }, md: { padding: "12px 20px", fontSize: 16 }, lg: { padding: "16px 28px", fontSize: 18 } };
  const variants = {
    primary: { background: disabled ? "var(--ld-gray-10)" : "var(--ld-blue-100)", color: disabled ? "var(--ld-gray-50)" : "#fff" },
    secondary: { background: "#fff", color: "var(--ld-text)", border: "1px solid var(--ld-gray-160)" },
    tertiary: { background: "transparent", color: "var(--ld-text-brand)" },
    destructive: { background: "var(--ld-red-100)", color: "#fff" },
  };
  return <button style={{ ...base, ...sizes[size], ...variants[variant] }} disabled={disabled} onClick={onClick}>{children}</button>;
}

/* ---------------- Component preview frame ---------------- */
function Preview({ children, bg = "var(--ld-bg)" }) {
  return (
    <div style={{ border: "1px solid var(--ld-gray-20)", borderRadius: 8, padding: 40, background: bg, display: "flex", gap: 16, alignItems: "center", justifyContent: "center", minHeight: 140, flexWrap: "wrap" }}>
      {children}
    </div>
  );
}

/* ---------------- styles ---------------- */
const ldStyles = {
  nav: { position: "sticky", top: 0, background: "#fff", borderBottom: "1px solid var(--ld-gray-20)", zIndex: 10, fontFamily: "var(--ld-font-sans)" },
  navInner: { display: "flex", alignItems: "center", gap: 32, padding: "14px 32px", maxWidth: 1440, margin: "0 auto" },
  brand: { display: "flex", alignItems: "center", gap: 10, textDecoration: "none", color: "var(--ld-text)" },
  logoMark: { width: 28, height: 28, borderRadius: 6, background: "var(--ld-blue-100)", position: "relative" },
  brandText: { fontWeight: 700, fontSize: 18, letterSpacing: "-0.01em" },
  version: { fontSize: 11, fontFamily: "var(--ld-font-mono)", background: "var(--ld-blue-10)", color: "var(--ld-blue-130)", padding: "2px 6px", borderRadius: 4 },
  navLinks: { display: "flex", gap: 2, flex: 1 },
  navLink: { textDecoration: "none", color: "var(--ld-text-subtle)", fontSize: 14, fontWeight: 400, padding: "8px 12px", borderRadius: 6 },
  navLinkActive: { color: "var(--ld-text)", fontWeight: 700 },
  navRight: { display: "flex", alignItems: "center", gap: 12 },
  search: { display: "flex", alignItems: "center", gap: 8, padding: "8px 12px", border: "1px solid var(--ld-gray-20)", borderRadius: 8, background: "var(--ld-gray-5)", minWidth: 240, cursor: "pointer" },
  kbd: { marginLeft: "auto", fontSize: 11, fontFamily: "var(--ld-font-mono)", background: "#fff", border: "1px solid var(--ld-gray-20)", padding: "1px 5px", borderRadius: 3, color: "var(--ld-text-subtle)" },
  ghLink: { color: "var(--ld-text-brand)", fontSize: 14, textDecoration: "none", fontWeight: 700 },
  side: { width: 240, flex: "0 0 240px", padding: "32px 16px 32px 32px", borderRight: "1px solid var(--ld-gray-10)", fontFamily: "var(--ld-font-sans)", fontSize: 14 },
  sideH: { fontSize: 11, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.06em", color: "var(--ld-text-subtlest)", padding: "0 12px 8px", fontFamily: "var(--ld-font-mono)" },
  sideItem: { display: "block", padding: "7px 12px", color: "var(--ld-text-subtle)", textDecoration: "none", borderRadius: 6, fontSize: 14 },
  sideItemActive: { background: "var(--ld-blue-10)", color: "var(--ld-text-brand)", fontWeight: 700 },
};

Object.assign(window, { TopNav, SideNav, Tabs, Code, PropTable, LDButton, Preview });
