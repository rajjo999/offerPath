import Foundation
import StoreKit

class SubscriptionManager: ObservableObject, SubscriptionManagerProtocol {
    // MARK: - Published Properties
    @Published var isLoading = true
    @Published var hasPremium = false
    @Published var subscriptionStatus: SubscriptionStatus = .unknown
    @Published var errorMessage: String? = nil
    @Published var products: [Product] = []

    // MARK: - Subscription Tiers
    enum SubscriptionTier: String, CaseIterable {
        case free = "Free"
        case proMonthly = "OfferPath Pro Monthly"
        case proYearly = "OfferPath Pro Yearly"

        var productId: String {
            switch self {
            case .free: return ""
            case .proMonthly: return "com.ranbir.offerpath.pro.monthly"
            case .proYearly: return "com.ranbir.offerpath.pro.yearly"
            }
        }

        var displayName: String {
            switch self {
            case .free: return "Free"
            case .proMonthly: return "Pro Monthly"
            case .proYearly: return "Pro Yearly"
            }
        }

        var priceDescription: String {
            switch self {
            case .free: return "Free"
            case .proMonthly: return "$4.99/month"
            case .proYearly: return "$49.99/year"
            }
        }
    }

    // MARK: - Subscription Status
    enum SubscriptionStatus {
        case unknown
        case free
        case subscribed
        case expired
        case error
    }

    // MARK: - Private Properties
    private var updates: Task<Void, Never>? = nil
    private let productIds: Set<String> = [
        SubscriptionTier.proMonthly.productId,
        SubscriptionTier.proYearly.productId
    ]

    // MARK: - Init
    init() {
        updates = observeSubscriptionUpdates()
        Task {
            await loadProducts()
            await updatePremiumStatus()
        }
    }

    deinit {
        updates?.cancel()
    }

    // MARK: - Public Methods
    func purchase(_ product: Product) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await product.purchase()

            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await deliver(transaction: transaction)
                return true

            case .userCancelled:
                return false

            case .pending:
                return false

            @unknown default:
                return false
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            return false
        }
    }

    func restorePurchases() async {
        isLoading = true
        defer { isLoading = false }

        do {
            try await AppStore.sync()
            await updatePremiumStatus()
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
        }
    }

    // MARK: - Private Methods
    private func observeSubscriptionUpdates() -> Task<Void, Never> {
        Task { [weak self] in
            for await _ in Transaction.updates {
                await self?.updatePremiumStatus()
            }
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIds)
            products.sort { $0.price > $1.price }
            isLoading = false
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            isLoading = false
        }
    }

    func updatePremiumStatus() async {
        isLoading = true
        defer { isLoading = false }

        do {
            // Check if any subscription is active
            var statuses: [String] = []
            for await verificationResult in Transaction.currentEntitlements {
                switch verificationResult {
                case .verified(let transaction):
                    if self.productIds.contains(transaction.productID) {
                        statuses.append(transaction.productID)
                    }
                case .unverified:
                    break
                }
            }

            hasPremium = !statuses.isEmpty
            subscriptionStatus = hasPremium ? .subscribed : .free
        }

    }

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    private func deliver(transaction: Transaction) async {
        await transaction.finish()
        await updatePremiumStatus()
    }

    // MARK: - Helper Methods
    func isSubscribed(to tier: SubscriptionTier) -> Bool {
        guard tier != .free else { return true }
        return hasPremium
    }

    func getProduct(for tier: SubscriptionTier) -> Product? {
        guard tier != .free else { return nil }
        return products.first { $0.id == tier.productId }
    }
}

// MARK: - Store Errors
enum StoreError: Error {
    case failedVerification
    case unknown
}