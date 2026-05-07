import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscription = SubscriptionManager.shared
    @State private var isYearly = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.yellow)
                        .padding(.top, 20)

                    Text("Unlock Flowboard Pro")
                        .font(.largeTitle)
                        .bold()

                    Text("Get unlimited boards, AI features, and more")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        featureRow(icon: "infinity", text: "Unlimited Boards")
                        featureRow(icon: "calendar", text: "Calendar View")
                        featureRow(icon: "text.bubble", text: "Natural Language Input")
                        featureRow(icon: "sparkles", text: "AI Task Breakdown")
                        featureRow(icon: "tag", text: "Custom Tags & Labels")
                        featureRow(icon: "square.and.arrow.up", text: "Export CSV/PDF")
                    }
                    .padding()

                    HStack(spacing: 12) {
                        planButton(
                            title: "Monthly",
                            price: subscription.monthlyProduct?.displayPrice ?? "$2.99",
                            isSelected: !isYearly
                        ) {
                            isYearly = false
                        }

                        planButton(
                            title: "Yearly",
                            price: subscription.yearlyProduct?.displayPrice ?? "$24.99",
                            subtitle: "Save 30%",
                            isSelected: isYearly
                        ) {
                            isYearly = true
                        }
                    }
                    .padding(.horizontal)

                    Button(action: purchase) {
                        Text("Start 7-Day Free Trial")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.flowPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)

                    Button("Restore Purchases") {
                        Task { await subscription.restorePurchases() }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text("Cancel anytime in Settings. Subscription auto-renews.")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func featureRow(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.flowPrimary)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
            Spacer()
        }
    }

    private func planButton(title: String, price: String, subtitle: String? = nil, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                Text(price)
                    .font(.title3)
                    .bold()
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.flowPrimary.opacity(0.1) : Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.flowPrimary : Color.clear, lineWidth: 2)
            )
        }
        .foregroundStyle(.primary)
    }

    private func purchase() {
        Task {
            let product = isYearly ? subscription.yearlyProduct : subscription.monthlyProduct
            if let product {
                let success = await subscription.purchase(product)
                if success { dismiss() }
            }
        }
    }
}
