/* Walmart.com UI kit — cosmetic recreation */
const { useState } = React;

/* ---------------- Icon ---------------- */
function Icon({ name, size = 20, color = "currentColor", style, ...rest }) {
  return (
    <img
      src={`../../assets/icons/${name}.svg`}
      width={size}
      height={size}
      style={{ display: "inline-block", verticalAlign: "middle", ...style }}
      alt=""
      {...rest}
    />
  );
}

/* ---------------- Header ---------------- */
function Header({ cartCount = 3, onSearch }) {
  const [q, setQ] = useState("");
  return (
    <header style={wmStyles.header}>
      <div style={wmStyles.headerTop}>
        <a href="#" style={wmStyles.logo} aria-label="Walmart">
          <img src="../../assets/walmart-spark.svg" width={32} height={32} />
          <span style={{ fontFamily: "var(--ld-font-sans)", fontWeight: 700, fontSize: 26, color: "#fff", letterSpacing: "-0.01em" }}>Walmart</span>
        </a>
        <button style={wmStyles.pickup}>
          <Icon name="Location" size={20} style={{ filter: "invert(1)" }} />
          <div style={{ textAlign: "left", lineHeight: 1.15 }}>
            <div style={{ fontSize: 12, opacity: 0.85 }}>Pickup or delivery?</div>
            <div style={{ fontSize: 14, fontWeight: 700 }}>Sacramento, 95829 ▾</div>
          </div>
        </button>
        <form style={wmStyles.searchWrap} onSubmit={(e) => { e.preventDefault(); onSearch && onSearch(q); }}>
          <input
            style={wmStyles.searchInput}
            placeholder="Search everything at Walmart online and in store"
            value={q}
            onChange={(e) => setQ(e.target.value)}
          />
          <button type="submit" style={wmStyles.searchBtn}><Icon name="Search" size={22} /></button>
        </form>
        <button style={wmStyles.iconBtn}><Icon name="Heart" size={20} style={{ filter: "invert(1)" }} /><span style={wmStyles.iconLabel}>Reorder<br/><b>My items</b></span></button>
        <button style={wmStyles.iconBtn}><Icon name="UserCircle" size={20} style={{ filter: "invert(1)" }} /><span style={wmStyles.iconLabel}>Sign in<br/><b>Account</b></span></button>
        <button style={wmStyles.cartBtn}>
          <div style={{ position: "relative" }}>
            <Icon name="Cart" size={24} style={{ filter: "invert(1)" }} />
            <span style={wmStyles.cartBadge}>{cartCount}</span>
          </div>
          <div style={{ fontSize: 12, lineHeight: 1.1, marginTop: 2, textAlign: "left" }}>
            <div style={{ opacity: 0.85, fontSize: 11 }}>$34.98</div>
          </div>
        </button>
      </div>
      <nav style={wmStyles.navBar}>
        {["Departments ▾", "Services ▾", "Get it Fast", "My Items", "Grocery & Essentials", "Home", "Electronics", "Fashion", "Pharmacy", "Registry", "Walmart+"].map((c) => (
          <a key={c} href="#" style={wmStyles.navLink}>{c}</a>
        ))}
      </nav>
    </header>
  );
}

const wmStyles = {
  header: { background: "var(--ld-blue-100)", color: "#fff", fontFamily: "var(--ld-font-sans)" },
  headerTop: { display: "flex", alignItems: "center", gap: 12, padding: "12px 24px" },
  logo: { display: "flex", alignItems: "center", gap: 6, textDecoration: "none", color: "#fff" },
  pickup: { display: "flex", alignItems: "center", gap: 8, background: "transparent", color: "#fff", border: "none", borderRadius: 20, padding: "6px 10px", cursor: "pointer" },
  searchWrap: { flex: 1, display: "flex", background: "#fff", borderRadius: 1000, overflow: "hidden", height: 44, border: "none" },
  searchInput: { flex: 1, border: "none", outline: "none", padding: "0 20px", fontSize: 14, color: "#2e2f32", fontFamily: "var(--ld-font-sans)" },
  searchBtn: { width: 48, border: "none", background: "var(--ld-spark-100)", borderRadius: "50%", margin: 2, cursor: "pointer" },
  iconBtn: { background: "transparent", border: "none", color: "#fff", display: "flex", alignItems: "center", gap: 8, padding: "8px 10px", borderRadius: 20, cursor: "pointer", fontFamily: "var(--ld-font-sans)" },
  iconLabel: { fontSize: 11, lineHeight: 1.2, textAlign: "left" },
  cartBtn: { background: "transparent", border: "none", color: "#fff", display: "flex", alignItems: "center", gap: 4, padding: "8px 10px", borderRadius: 20, cursor: "pointer" },
  cartBadge: { position: "absolute", top: -4, right: -6, background: "var(--ld-spark-100)", color: "var(--ld-gray-170)", fontWeight: 700, fontSize: 11, borderRadius: 1000, padding: "0 6px", minWidth: 16, textAlign: "center", lineHeight: "16px" },
  navBar: { display: "flex", gap: 24, padding: "0 24px 12px", fontSize: 14, alignItems: "center", overflowX: "auto" },
  navLink: { color: "#fff", textDecoration: "none", whiteSpace: "nowrap", fontWeight: 400 },
};

Object.assign(window, { Icon, Header });
