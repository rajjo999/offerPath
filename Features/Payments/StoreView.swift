import SwiftUI
import StoreKit

struct StoreView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var subscriptionManager = SubscriptionManager()

    var body: some View {
        NavigationStack {
            ZStack {
                ColorTokens.background.ignoresSafeArea()

                if subscriptionManager.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: ColorTokens.primaryGreen))
                        Text("Loading...")
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .foregroundStyle(ColorTokens.secondaryText)
                            .padding(.top, Spacing.medium)
                    }
                } else if let errorMessage = subscriptionManager.errorMessage {
                    VStack(spacing: Spacing.medium) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)

                        Text("Error")
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(.primary)

                        Text(errorMessage)
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        Button(action: {
                            Task {
                                await subscriptionManager.loadProducts()
                                await subscriptionManager.updatePremiumStatus()
                            }
                        }) {
                            Text("Retry")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(width: 120, height: 44)
                                .background(ColorTokens.primaryGreen)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 24)
                    }
                    .padding()
                } else {
                    VStack(spacing: Spacing.large) {
                        headerSection

                        if !subscriptionManager.hasPremium {
                            plansSection
                        } else {
                            premiumSection
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("OfferPath Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(ColorTokens.primaryGreen)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: Spacing.xSmall) {
            Text("UNLOCK PREMIUM FEATURES")
                .font(
                    .system(
                        size: 22,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)

            Text("Take your job search to the next level")
                .font(
                    .system(
                        size: 16,
                        weight: .medium,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.secondaryText)
        }
        .padding(.top, Spacing.large)
    }

    private var plansSection: some View {
        VStack(spacing: Spacing.large) {
            Text("CHOOSE YOUR PLAN")
                .font(
                    .system(
                        size: 18,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)

            VStack(spacing: Spacing.medium) {
                ForEach(SubscriptionManager.SubscriptionTier.allCases.filter { $0 != .free }, id: \.self) { tier in
                    if let product = subscriptionManager.getProduct(for: tier) {
                        PlanCard(
                            tier: tier,
                            product: product,
                            isSelected: false,
                            action: {
                                Task {
                                    do {
                                        let success = try await subscriptionManager.purchase(product)
                                        if success {
                                            // Dismiss will be handled by parent or show success
                                        }
                                    } catch {
                                        // Error handling is done by SubscriptionManager
                                    }
                                }
                            }
                        )
                    }
                }
            }

            Button(action: {
                Task {
                    await subscriptionManager.restorePurchases()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Restore Purchases")
                }
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundStyle(ColorTokens.primaryGreen)
            }
        }
    }

    private var premiumSection: some View {
        VStack(spacing: Spacing.large) {
            VStack(spacing: Spacing.xSmall) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(ColorTokens.primaryGreen)

                Text("Welcome to OfferPath Pro!")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.primaryGreen)

                Text("You now have access to all premium features")
                    .font(
                        .system(
                            size: 16,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .leading, spacing: Spacing.medium) {
                FeatureRow(icon: "brain.head.profile", title: "AI Coach", description: "Interview prep, resume optimization, networking strategies")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Advanced Analytics", description: "Deep insights into your job search performance")
                FeatureRow(icon: "infinity", title: "Unlimited Applications", description: "No limits on job applications or follow-ups")
                FeatureRow(icon: "crown", title: "Priority Support", description: "Get help faster with dedicated support")
            }

            Button(action: {
                dismiss()
            }) {
                Text("Start Using Pro Features")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(ColorTokens.primaryGreen)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func FeatureRow(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(ColorTokens.primaryGreen)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundColor(.primary)

                Text(description)
                    .font(.system(size: 14, weight: .regular, design: .monospaced))
                    .foregroundColor(ColorTokens.secondaryText)
            }
        }
        .padding()
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTokens.borderGreen, lineWidth: 1)
        }
    }
}

struct PlanCard: View {
    let tier: SubscriptionManager.SubscriptionTier
    let product: Product
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: Spacing.medium) {
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text(tier.displayName)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundColor(ColorTokens.primaryGreen)

                Text(tier.priceDescription)
                    .font(.system(size: 16, weight: .medium, design: .monospaced))
                    .foregroundColor(ColorTokens.highlightGreen)
            }

            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text("Get access to:")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundColor(ColorTokens.secondaryText)

                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                    Text("• AI Coach with interview preparation")
                    Text("• Resume optimization tools")
                    Text("• Advanced job search analytics")
                    Text("• Networking strategy guides")
                    Text("• Unlimited applications & follow-ups")
                    Text("• Priority customer support")
                }
                .font(.system(size: 13, weight: .regular, design: .monospaced))
                .foregroundColor(ColorTokens.secondaryText)
            }

            Button(action: action) {
                HStack {
                    Text("Subscribe")
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))

                    Image(systemName: "arrow.right")
                        .font(.system(size: 16, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(ColorTokens.primaryGreen)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? ColorTokens.primaryGreen : ColorTokens.borderGreen, lineWidth: isSelected ? 2 : 1)
        }
    }
}