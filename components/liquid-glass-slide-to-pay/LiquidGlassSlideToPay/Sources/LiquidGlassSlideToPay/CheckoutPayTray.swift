import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// The floating glass tray at the bottom of checkout: total, the slide control, and the legal line.
///
/// Place it over scrolling content with `ZStack(alignment: .bottom)` and give the content enough
/// bottom padding to scroll out from underneath.
public struct CheckoutPayTray: View {
    public var total: String
    public var itemCount: Int
    @Binding public var isComplete: Bool
    public var onComplete: () -> Void

    public init(
        total: String,
        itemCount: Int,
        isComplete: Binding<Bool>,
        onComplete: @escaping () -> Void = {}
    ) {
        self.total = total
        self.itemCount = itemCount
        self._isComplete = isComplete
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                (Text("Total ").font(SamsSans.ui(22, weight: .semibold, relativeTo: .title2))
                    + Text("(\(itemCount) items)").font(SamsSans.ui(19, weight: .regular, relativeTo: .title3)))
                Spacer()
                Text(total)
                    .font(SamsSans.ui(22, weight: .semibold, relativeTo: .title2))
                    .monospacedDigit()
            }
            .padding(.horizontal, 6)

            SlideToPayControl(
                amountDescription: total,
                isComplete: $isComplete,
                onComplete: onComplete
            )

            Text("By sliding to pay, you agree to our [Privacy Policy](https://www.samsclub.com/privacy) and [Terms of Use](https://www.samsclub.com/terms)")
                .font(SamsSans.ui(12, weight: .regular, relativeTo: .caption))
                .tint(SamsClubColor.clubBlue)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 6)
        }
        .padding(EdgeInsets(top: 14, leading: 16, bottom: 12, trailing: 16))
        .liquidGlass(.regular, in: RoundedRectangle(cornerRadius: 34, style: .continuous))
    }
}

/// A checkout screen to exercise the tray: a Club Blue header, scrolling cards, and the tray on top.
public struct SlideToPayDemo: View {
    @State private var isComplete = false

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 14) {
                    deliveryCard
                    paymentCard
                    summaryCard
                    Text("Plus members get free delivery on orders over $50.")
                        .font(SamsSans.ui(13, relativeTo: .footnote))
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding(16)
                .padding(.bottom, 220)
            }
            .background(backgroundColor)

            CheckoutPayTray(total: "$148.45", itemCount: 4, isComplete: $isComplete)
                .padding(12)
        }
        .safeAreaInset(edge: .top, spacing: 0) { header }
    }

    private var backgroundColor: Color {
        #if canImport(UIKit)
        return Color(uiColor: .systemBackground)
        #else
        return Color.white
        #endif
    }

    // MARK: Header

    private var header: some View {
        ZStack {
            Text("Checkout")
                .font(SamsSans.ui(20, weight: .semibold, relativeTo: .headline))
                .foregroundStyle(.white)
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.leading, 8)
                Spacer()
                if isComplete {
                    Button("Reset") {
                        isComplete = false
                    }
                    .font(SamsSans.ui(13, weight: .semibold, relativeTo: .footnote))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .liquidGlass(.regular, in: Capsule(), interactive: true)
                    .padding(.trailing, 8)
                    .transition(.opacity)
                }
            }
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(SamsClubColor.clubBlue)
        .animation(.easeOut(duration: 0.25), value: isComplete)
    }

    // MARK: Cards

    private var deliveryCard: some View {
        card {
            HStack(spacing: 12) {
                SamsClubMark.logomark
                    .resizable()
                    .scaledToFit()
                    .frame(height: 29)
                Text("Delivery from club")
                    .font(SamsSans.ui(22, weight: .semibold, relativeTo: .title2))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(SamsClubColor.lightBlue.opacity(0.18))

            VStack(alignment: .leading, spacing: 10) {
                Text("Tomorrow, 8am-10am")
                    .font(SamsSans.ui(22, weight: .semibold, relativeTo: .title2))
                Text("Jordan Reyes")
                Text("1000 S 8th St, Bentonville, AR 72712")
                Divider().padding(.vertical, 6)
                HStack {
                    Text("Delivery preference ").font(SamsSans.ui(16, weight: .semibold)) + Text("(optional)")
                    Spacer()
                    Text("Add").underline()
                }
                HStack(spacing: 12) {
                    choice("Leave at door", selected: true)
                    choice("Greet driver", selected: false)
                }
                Divider().padding(.vertical, 6)
                Text("Say thanks with a tip! ").font(SamsSans.ui(20, weight: .semibold, relativeTo: .title3)) + Text("(Optional)").font(SamsSans.ui(20, relativeTo: .title3))
                Text("100% of tips go to the drivers.")
                    .font(SamsSans.ui(13, relativeTo: .footnote))
                    .foregroundStyle(.secondary)
                HStack(spacing: 8) {
                    ForEach(["5%", "10%", "15%", "No tip", "Custom"], id: \.self) { tip in
                        tipChip(tip, selected: tip == "10%")
                    }
                }
            }
            .padding(16)
        }
    }

    private var paymentCard: some View {
        card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Payment").font(SamsSans.ui(16, weight: .semibold))
                    Spacer()
                    Text("Change").underline()
                }
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(SamsClubColor.clubBlue)
                        .frame(width: 40, height: 26)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Sam’s Club Mastercard")
                        Text("Ending in 4821 · 5% cash back on this order")
                            .font(SamsSans.ui(13, relativeTo: .footnote))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(16)
        }
    }

    private var summaryCard: some View {
        card {
            VStack(alignment: .leading, spacing: 8) {
                Text("Order summary").font(SamsSans.ui(16, weight: .semibold))
                    .padding(.bottom, 4)
                summaryRow("Subtotal (4 items)", "$122.47")
                summaryRow("Delivery fee", "$12.00")
                summaryRow("Tip (10%)", "$12.25")
                summaryRow("Estimated tax", "$1.73")
                Divider().padding(.vertical, 4)
                summaryRow("Total", "$148.45", emphasized: true)
            }
            .padding(16)
        }
    }

    // MARK: Pieces

    private func card<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 0, content: content)
            .font(SamsSans.ui(15))
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(Color.secondary.opacity(0.25)))
    }

    private func choice(_ title: String, selected: Bool) -> some View {
        Text(title)
            .font(SamsSans.ui(15, weight: selected ? .semibold : .medium))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(selected ? Color.primary : Color.secondary, lineWidth: selected ? 2 : 1))
    }

    private func tipChip(_ title: String, selected: Bool) -> some View {
        Text(title)
            .font(SamsSans.ui(13, weight: selected ? .semibold : .medium))
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(selected ? SamsClubColor.lightBlue.opacity(0.25) : .clear)
            .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(selected ? SamsClubColor.clubBlue : Color.secondary, lineWidth: selected ? 2 : 1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func summaryRow(_ label: String, _ value: String, emphasized: Bool = false) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).monospacedDigit()
        }
        .font(SamsSans.ui(emphasized ? 17 : 15, weight: emphasized ? .semibold : .regular))
    }
}

#Preview("Checkout, tinted") {
    SlideToPayDemo()
}

#Preview("Checkout, dark") {
    SlideToPayDemo()
        .preferredColorScheme(.dark)
}
