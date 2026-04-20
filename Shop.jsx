/* Walmart.com UI kit — PDP, cart, category hero components */
const { useState } = React;

/* ---------------- Hero banner strip ---------------- */
function HeroStrip() {
  return (
    <div style={heroStripStyles.wrap}>
      <div style={heroStripStyles.spark}><img src="../../assets/walmart-spark.svg" width={20} height={20}/> Walmart+ members get free delivery from store. <a href="#" style={heroStripStyles.link}>Join now</a></div>
    </div>
  );
}
const heroStripStyles = {
  wrap: { background: "var(--ld-gray-170)", color: "#fff", padding: "10px 24px", fontFamily: "var(--ld-font-sans)", fontSize: 14, display: "flex", justifyContent: "center" },
  spark: { display: "flex", alignItems: "center", gap: 8 },
  link: { color: "var(--ld-spark-100)", fontWeight: 700, marginLeft: 6, textDecoration: "underline" },
};

/* ---------------- Category tiles ---------------- */
function CategoryTiles() {
  const cats = [
    { label: "Groceries", bg: "#e9f1fe", swatch: "#79cdf6" },
    { label: "Home", bg: "#fff3d2", swatch: "#ffc220" },
    { label: "Fashion", bg: "#fce9f5", swatch: "#ea9ac3" },
    { label: "Electronics", bg: "#e1f3f8", swatch: "#5dc3da" },
    { label: "Pharmacy", bg: "#eaf3e6", swatch: "#95c381" },
    { label: "Auto", bg: "#efebf2", swatch: "#b199bf" },
    { label: "Baby", bg: "#fff0e6", swatch: "#fdb280" },
    { label: "Patio", bg: "#f4f9f2", swatch: "#2a8703" },
  ];
  return (
    <div style={catStyles.wrap}>
      {cats.map(c => (
        <a key={c.label} style={{ ...catStyles.tile, background: c.bg }} href="#">
          <div style={{ ...catStyles.swatch, background: c.swatch }}/>
          <div style={catStyles.label}>{c.label}</div>
        </a>
      ))}
    </div>
  );
}
const catStyles = {
  wrap: { display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16 },
  tile: { borderRadius: 16, padding: 16, minHeight: 120, display: "flex", flexDirection: "column", justifyContent: "flex-end", textDecoration: "none", color: "var(--ld-text)", fontFamily: "var(--ld-font-sans)" },
  swatch: { width: 48, height: 48, borderRadius: 1000, alignSelf: "flex-end" },
  label: { fontWeight: 700, fontSize: 16, marginTop: 12 },
};

/* ---------------- Product card ---------------- */
function ProductCard({ p, onAdd, inCart }) {
  return (
    <div style={pcStyles.card}>
      <div style={pcStyles.imgBox}>
        {p.tag && <div style={{ ...pcStyles.tag, background: p.tag === "Clearance" ? "var(--ld-red-100)" : "var(--ld-spark-100)", color: p.tag === "Clearance" ? "#fff" : "var(--ld-gray-170)" }}>{p.tag}</div>}
        <div style={pcStyles.imgPh}>{p.name.split(" ")[0]}</div>
        <button style={pcStyles.heart}><img src="../../assets/icons/Heart.svg" width={16} height={16}/></button>
      </div>
      <div style={pcStyles.priceRow}>
        <span style={pcStyles.price}>${p.price.toFixed(2)}</span>
        {p.wasPrice && <span style={pcStyles.was}>${p.wasPrice.toFixed(2)}</span>}
      </div>
      {p.wasPrice && <div style={pcStyles.save}>You save ${(p.wasPrice - p.price).toFixed(2)}</div>}
      <div style={pcStyles.name}>{p.name}</div>
      <div style={pcStyles.rating}>★ {p.rating} <span style={{ color: "var(--ld-text-subtle)" }}>({p.reviews.toLocaleString()})</span></div>
      <div style={pcStyles.delivery}>Free pickup <b>today</b> · Get it by <b>Thu, Oct 24</b></div>
      <button style={{ ...pcStyles.add, ...(inCart ? pcStyles.addInCart : {}) }} onClick={() => onAdd && onAdd(p)}>{inCart ? "✓ Added" : "Add to cart"}</button>
    </div>
  );
}
const pcStyles = {
  card: { background: "#fff", borderRadius: 8, border: "1px solid var(--ld-gray-20)", padding: 14, fontFamily: "var(--ld-font-sans)", display: "flex", flexDirection: "column", gap: 6 },
  imgBox: { position: "relative", height: 180, background: "var(--ld-gray-5)", borderRadius: 6, display: "flex", alignItems: "center", justifyContent: "center", marginBottom: 4 },
  imgPh: { color: "var(--ld-gray-50)", fontFamily: "var(--ld-font-mono)", fontSize: 13 },
  tag: { position: "absolute", top: 10, left: 10, fontSize: 11, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.02em", padding: "3px 8px", borderRadius: 4 },
  heart: { position: "absolute", top: 10, right: 10, background: "#fff", border: "1px solid var(--ld-gray-20)", width: 32, height: 32, borderRadius: 1000, cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" },
  priceRow: { display: "flex", alignItems: "baseline", gap: 8 },
  price: { fontSize: 24, fontWeight: 700, color: "var(--ld-text)" },
  was: { fontSize: 13, color: "var(--ld-text-subtle)", textDecoration: "line-through" },
  save: { color: "var(--ld-text-positive-bold)", fontSize: 12, fontWeight: 700 },
  name: { fontSize: 14, lineHeight: "18px", color: "var(--ld-text)", display: "-webkit-box", WebkitLineClamp: 2, WebkitBoxOrient: "vertical", overflow: "hidden" },
  rating: { fontSize: 13, color: "var(--ld-text)" },
  delivery: { fontSize: 12, color: "var(--ld-text-subtle)", lineHeight: "16px" },
  add: { marginTop: 8, background: "var(--ld-blue-100)", color: "#fff", border: "none", borderRadius: 1000, padding: "10px 16px", fontWeight: 700, fontSize: 14, cursor: "pointer", fontFamily: "var(--ld-font-sans)" },
  addInCart: { background: "var(--ld-white)", color: "var(--ld-text)", border: "1px solid var(--ld-gray-160)" },
};

/* ---------------- Product shelf ---------------- */
function Shelf({ title, subtitle, children }) {
  return (
    <section style={{ padding: "24px 0", fontFamily: "var(--ld-font-sans)" }}>
      <div style={{ display: "flex", alignItems: "baseline", justifyContent: "space-between", marginBottom: 16 }}>
        <div>
          <div style={{ fontSize: 24, fontWeight: 700, color: "var(--ld-text)" }}>{title}</div>
          {subtitle && <div style={{ fontSize: 14, color: "var(--ld-text-subtle)", marginTop: 4 }}>{subtitle}</div>}
        </div>
        <a href="#" style={{ color: "var(--ld-text-brand)", fontWeight: 700, fontSize: 14, textDecoration: "none" }}>Shop all →</a>
      </div>
      <div>{children}</div>
    </section>
  );
}

/* ---------------- Cart drawer ---------------- */
function CartDrawer({ open, onClose, items, onRemove }) {
  const subtotal = items.reduce((s, it) => s + it.price * it.qty, 0);
  if (!open) return null;
  return (
    <div style={drawerStyles.scrim} onClick={onClose}>
      <aside style={drawerStyles.panel} onClick={(e) => e.stopPropagation()}>
        <header style={drawerStyles.head}>
          <div style={{ fontSize: 20, fontWeight: 700 }}>Cart ({items.length})</div>
          <button style={drawerStyles.close} onClick={onClose}><img src="../../assets/icons/Close.svg" width={20}/></button>
        </header>
        <div style={drawerStyles.list}>
          {items.length === 0 && <div style={{ padding: 24, color: "var(--ld-text-subtle)", textAlign: "center" }}>No items yet. Add things to your cart to see them here.</div>}
          {items.map(it => (
            <div key={it.id} style={drawerStyles.row}>
              <div style={drawerStyles.thumb}>{it.name.split(" ")[0][0]}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: 14, lineHeight: "18px" }}>{it.name}</div>
                <div style={{ fontSize: 13, color: "var(--ld-text-subtle)", marginTop: 4 }}>Qty {it.qty}</div>
              </div>
              <div style={{ textAlign: "right" }}>
                <div style={{ fontWeight: 700 }}>${(it.price * it.qty).toFixed(2)}</div>
                <button style={drawerStyles.rm} onClick={() => onRemove(it)}>Remove</button>
              </div>
            </div>
          ))}
        </div>
        <footer style={drawerStyles.foot}>
          <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, marginBottom: 6 }}>
            <span style={{ color: "var(--ld-text-subtle)" }}>Subtotal</span><span style={{ fontWeight: 700 }}>${subtotal.toFixed(2)}</span>
          </div>
          <div style={{ display: "flex", justifyContent: "space-between", fontSize: 14, marginBottom: 12 }}>
            <span style={{ color: "var(--ld-text-subtle)" }}>Free pickup today</span><span style={{ color: "var(--ld-text-positive-bold)" }}>Free</span>
          </div>
          <button style={drawerStyles.checkout} disabled={items.length === 0}>Check out · ${subtotal.toFixed(2)}</button>
          <button style={drawerStyles.continue} onClick={onClose}>Continue shopping</button>
        </footer>
      </aside>
    </div>
  );
}
const drawerStyles = {
  scrim: { position: "fixed", inset: 0, background: "rgba(0,0,0,0.5)", zIndex: 100, display: "flex", justifyContent: "flex-end", fontFamily: "var(--ld-font-sans)" },
  panel: { background: "#fff", width: 420, height: "100%", display: "flex", flexDirection: "column", boxShadow: "var(--ld-elevation-300)" },
  head: { display: "flex", alignItems: "center", justifyContent: "space-between", padding: "20px 24px", borderBottom: "1px solid var(--ld-gray-20)" },
  close: { background: "transparent", border: "none", cursor: "pointer", padding: 4 },
  list: { flex: 1, overflow: "auto", padding: "8px 16px" },
  row: { display: "flex", gap: 12, padding: "16px 8px", borderBottom: "1px solid var(--ld-gray-10)", alignItems: "flex-start" },
  thumb: { width: 56, height: 56, background: "var(--ld-gray-5)", borderRadius: 6, color: "var(--ld-gray-50)", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700 },
  rm: { background: "transparent", border: "none", color: "var(--ld-text-brand)", fontSize: 12, fontWeight: 700, cursor: "pointer", padding: 0, marginTop: 4 },
  foot: { padding: "20px 24px", borderTop: "1px solid var(--ld-gray-20)" },
  checkout: { width: "100%", background: "var(--ld-blue-100)", color: "#fff", border: "none", borderRadius: 1000, padding: "14px", fontWeight: 700, fontSize: 16, cursor: "pointer" },
  continue: { width: "100%", marginTop: 8, background: "#fff", color: "var(--ld-text)", border: "1px solid var(--ld-gray-160)", borderRadius: 1000, padding: "12px", fontWeight: 700, fontSize: 14, cursor: "pointer" },
};

Object.assign(window, { HeroStrip, CategoryTiles, ProductCard, Shelf, CartDrawer });
