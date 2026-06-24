const { useState } = React;

function App() {
  const [cart, setCart] = useState([]);
  const [drawer, setDrawer] = useState(false);

  const products = [
    { id: 1, name: "Great Value whole milk, vitamin D, 1 gallon", price: 4.98, rating: 4.7, reviews: 12041, tag: "Rollback", wasPrice: 6.98 },
    { id: 2, name: "Hanes Men's comfort-fit crew t-shirt, 4-pack", price: 28.98, rating: 4.5, reviews: 3221 },
    { id: 3, name: "Mainstays 3-piece kitchen towel set, gray", price: 12.5, rating: 4.8, reviews: 842, tag: "Clearance", wasPrice: 29.99 },
    { id: 4, name: "Fresh organic Fuji apples, 2 lb bag", price: 3.88, rating: 4.6, reviews: 520 },
    { id: 5, name: "onn. 50\" 4K UHD smart TV with Roku, model 50R1", price: 248.0, rating: 4.4, reviews: 9801, tag: "Rollback", wasPrice: 298.0 },
    { id: 6, name: "Equate ibuprofen tablets 200mg, 500 ct", price: 6.78, rating: 4.8, reviews: 1402 },
    { id: 7, name: "No Boundaries women's high-rise skinny jeans", price: 14.98, rating: 4.3, reviews: 2201 },
    { id: 8, name: "Marketside Cafe Caesar salad bowl, 6 oz", price: 4.42, rating: 4.5, reviews: 311 },
  ];

  const add = (p) => {
    const existing = cart.find(c => c.id === p.id);
    if (existing) setCart(cart.map(c => c.id === p.id ? { ...c, qty: c.qty + 1 } : c));
    else setCart([...cart, { ...p, qty: 1 }]);
  };
  const remove = (p) => setCart(cart.filter(c => c.id !== p.id));

  return (
    <div style={{ background: "var(--ld-bg)", minHeight: "100vh" }}>
      <Header cartCount={cart.reduce((s, c) => s + c.qty, 0)} onSearch={() => {}} />
      <HeroStrip />

      <main style={{ maxWidth: 1440, margin: "0 auto", padding: "24px" }}>
        {/* Hero */}
        <section style={{ display: "grid", gridTemplateColumns: "2fr 1fr", gap: 16, marginBottom: 24 }}>
          <div style={{ background: "var(--ld-blue-100)", borderRadius: 16, padding: 48, color: "#fff", minHeight: 320, display: "flex", flexDirection: "column", justifyContent: "space-between", position: "relative", overflow: "hidden" }}>
            <div style={{ position: "absolute", right: -40, bottom: -40, opacity: 0.18 }}>
              <img src="../../assets/walmart-spark.svg" width={360} height={360} />
            </div>
            <div style={{ position: "relative" }}>
              <div style={{ fontSize: 14, fontWeight: 700, textTransform: "uppercase", letterSpacing: "0.04em", opacity: 0.8, color: "#fff" }}>Rollback savings</div>
              <h1 style={{ fontSize: 56, fontWeight: 700, margin: "12px 0 8px", letterSpacing: "-0.01em", lineHeight: 1.05, color: "#fff" }}>Fall finds,<br/>big savings</h1>
              <div style={{ fontSize: 18, opacity: 0.95, maxWidth: 420, color: "#fff" }}>Save up to 40% on seasonal essentials. Free pickup today.</div>
            </div>
            <button style={{ alignSelf: "flex-start", background: "#fff", color: "var(--ld-text)", border: "none", borderRadius: 1000, padding: "14px 28px", fontWeight: 700, fontSize: 16, cursor: "pointer", position: "relative" }}>Shop rollbacks</button>
          </div>
          <div style={{ background: "var(--ld-spark-100)", borderRadius: 16, padding: 32, color: "var(--ld-gray-170)", display: "flex", flexDirection: "column", justifyContent: "space-between" }}>
            <div>
              <div style={{ display: "inline-block", background: "var(--ld-gray-170)", color: "#fff", padding: "3px 8px", fontSize: 11, fontWeight: 700, textTransform: "uppercase", borderRadius: 4 }}>New</div>
              <h2 style={{ fontSize: 32, fontWeight: 700, margin: "12px 0 8px", lineHeight: 1.1 }}>Fresh produce, delivered.</h2>
              <div style={{ fontSize: 15 }}>Same-day from your store.</div>
            </div>
            <a href="#" style={{ color: "var(--ld-gray-170)", fontWeight: 700, fontSize: 15 }}>Shop groceries →</a>
          </div>
        </section>

        {/* Categories */}
        <Shelf title="Shop by category">
          <CategoryTiles />
        </Shelf>

        {/* Rollbacks */}
        <Shelf title="Rollbacks & more" subtitle="Prices that won't last long.">
          <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16 }}>
            {products.slice(0, 4).map(p => (
              <ProductCard key={p.id} p={p} onAdd={add} inCart={!!cart.find(c => c.id === p.id)} />
            ))}
          </div>
        </Shelf>

        <Shelf title="Popular in your area" subtitle="Get it by Thursday.">
          <div style={{ display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 16 }}>
            {products.slice(4, 8).map(p => (
              <ProductCard key={p.id} p={p} onAdd={add} inCart={!!cart.find(c => c.id === p.id)} />
            ))}
          </div>
        </Shelf>

        <section style={{ background: "var(--ld-gray-5)", borderRadius: 16, padding: 40, display: "flex", gap: 32, alignItems: "center", marginTop: 24 }}>
          <img src="../../assets/walmart-spark.svg" width={80} height={80} />
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14, fontWeight: 700, color: "var(--ld-text-brand)", textTransform: "uppercase", letterSpacing: "0.04em" }}>Walmart+</div>
            <h2 style={{ fontSize: 32, fontWeight: 700, margin: "8px 0" }}>Save money. Save time.</h2>
            <div style={{ color: "var(--ld-text-subtle)", fontSize: 16 }}>Free same-day delivery, fuel savings, and member prices — $12.95/mo.</div>
          </div>
          <button style={{ background: "var(--ld-blue-100)", color: "#fff", border: "none", borderRadius: 1000, padding: "14px 28px", fontWeight: 700, fontSize: 16, cursor: "pointer" }}>Start free trial</button>
        </section>
      </main>

      <footer style={{ background: "var(--ld-gray-170)", color: "#fff", padding: "40px 24px", marginTop: 40, fontFamily: "var(--ld-font-sans)" }}>
        <div style={{ maxWidth: 1440, margin: "0 auto", display: "grid", gridTemplateColumns: "repeat(4, 1fr)", gap: 32, fontSize: 14 }}>
          <div>
            <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 16 }}>
              <img src="../../assets/walmart-spark.svg" width={28} height={28} />
              <span style={{ fontSize: 20, fontWeight: 700 }}>Walmart</span>
            </div>
            <div style={{ opacity: 0.7, lineHeight: 1.5 }}>Save money. Live better.</div>
          </div>
          {[
            { h: "All departments", l: ["Grocery & essentials", "Home", "Electronics", "Fashion"] },
            { h: "Services", l: ["Walmart+", "Pharmacy", "Auto care", "Returns"] },
            { h: "Account", l: ["Sign in", "Create account", "Wallet", "Order history"] },
          ].map(col => (
            <div key={col.h}>
              <div style={{ fontWeight: 700, marginBottom: 12 }}>{col.h}</div>
              {col.l.map(item => <div key={item} style={{ opacity: 0.8, marginBottom: 8 }}>{item}</div>)}
            </div>
          ))}
        </div>
      </footer>

      {/* Floating cart button */}
      <button style={{ position: "fixed", bottom: 24, right: 24, background: "var(--ld-spark-100)", color: "var(--ld-gray-170)", border: "none", borderRadius: 1000, padding: "16px 24px", fontWeight: 700, fontSize: 16, cursor: "pointer", boxShadow: "var(--ld-elevation-300)", display: "flex", alignItems: "center", gap: 8, fontFamily: "var(--ld-font-sans)" }} onClick={() => setDrawer(true)}>
        <img src="../../assets/icons/Cart.svg" width={20} height={20} />
        View cart · {cart.reduce((s, c) => s + c.qty, 0)}
      </button>

      <CartDrawer open={drawer} onClose={() => setDrawer(false)} items={cart} onRemove={remove} />
    </div>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<App />);
