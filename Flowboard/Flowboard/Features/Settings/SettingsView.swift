import SwiftUI

struct SettingsView: View {
    @StateObject private var subscription = SubscriptionManager.shared
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section("Subscription") {
                    HStack {
                        Text("Status")
                        Spacer()
                        Text(subscription.isPro ? "Pro" : "Free")
                            .foregroundStyle(subscription.isPro ? .green : .secondary)
                    }

                    if !subscription.isPro {
                        Button("Upgrade to Pro") {
                            showingPaywall = true
                        }
                    }

                    Button("Restore Purchases") {
                        Task {
                            await subscription.restorePurchases()
                        }
                    }
                }

                Section("Support") {
                    NavigationLink("Contact Us") {
                        ContactSupportView()
                    }
                }

                Section("Legal") {
                    Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/Flowboard/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/Flowboard/terms.html")!)
                    Link("Support", destination: URL(string: "https://asunnyboy861.github.io/Flowboard/support.html")!)
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}
