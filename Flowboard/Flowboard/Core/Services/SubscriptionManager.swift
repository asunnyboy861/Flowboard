import Combine
import StoreKit

@MainActor
final class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()

    @Published var isPro = false
    @Published var monthlyProduct: Product?
    @Published var yearlyProduct: Product?
    @Published var isLoading = false

    private var updateTask: Task<Void, Never>?

    private let monthlyID = "com.zzoutuo.Flowboard.monthly"
    private let yearlyID = "com.zzoutuo.Flowboard.yearly"

    init() {
        updateTask = Task {
            await loadProducts()
            await listenForTransactions()
        }
    }

    func loadProducts() async {
        isLoading = true
        do {
            let products = try await Product.products(for: [monthlyID, yearlyID])
            for product in products {
                switch product.id {
                case monthlyID: monthlyProduct = product
                case yearlyID: yearlyProduct = product
                default: break
                }
            }
            await updateSubscriptionStatus()
        } catch {
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await transaction.finish()
                    await updateSubscriptionStatus()
                    return true
                }
                return false
            case .pending, .userCancelled:
                return false
            @unknown default:
                return false
            }
        } catch {
            print("Purchase failed: \(error)")
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("Restore failed: \(error)")
        }
    }

    private func updateSubscriptionStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                if transaction.productID == monthlyID || transaction.productID == yearlyID {
                    isPro = transaction.revocationDate == nil
                    return
                }
            }
        }
        isPro = false
    }

    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                await transaction.finish()
                await updateSubscriptionStatus()
            }
        }
    }
}
