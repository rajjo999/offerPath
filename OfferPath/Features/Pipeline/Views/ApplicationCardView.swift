import SwiftUI

final class DateProvider: ObservableObject {
    static let shared = DateProvider()
    @Published var currentDate = Date()
    private var timer: Timer?
    private let calendar = Calendar.current
    private init() {
        setupTimer()
    }
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { [weak self] _ in
            self?.checkDateChange()
        }
        checkDateChange()
    }
    private func checkDateChange() {
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        if let lastUpdateDate = self.lastUpdateDate {
            let startOfLastUpdateDay = calendar.startOfDay(for: lastUpdateDate)
            if startOfToday != startOfLastUpdateDay {
                // Day changed
                currentDate = now
                self.lastUpdateDate = now
                return
               }
        } else {
            // First time
            currentDate = now
            self.lastUpdateDate = now
        }
    }
    private var lastUpdateDate: Date?
}

struct ApplicationCardView: View {
    let application: JobApplication
    let onTap: () -> Void
    let onStageChange: (ApplicationStage) -> Void

    @StateObject private var dateProvider = DateProvider.shared

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            VStack(
                alignment: .leading,
                spacing: Spacing.xxxSmall
            ) {
                Text(application.position)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.highlightGreen)
                    .lineLimit(2)

                Text(application.company)
                    .font(
                        .system(
                            size: 11,
                            weight: .regular,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
                    .lineLimit(1)
            }

            Spacer(minLength: 4)

            HStack(spacing: Spacing.xSmall) {
                Text(application.stage.displayName)
                    .font(
                        .system(
                            size: 10,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(application.stage.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                application.stage.color.opacity(0.6),
                                lineWidth: 1
                            )
                    }

                Text("\(daysSinceApplied)d")
                    .font(
                        .system(
                            size: 10,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            Spacer(minLength: 4)

            HStack {
                Button {
                    onTap()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(ColorTokens.primaryGreen)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Open application details")

                Spacer()

                Menu {
                    stageButton(
                        "Move to Applied",
                        stage: .applied
                    )

                    stageButton(
                        "Move to Recruiter Screen",
                        stage: .recruiterScreen
                    )

                    stageButton(
                        "Move to Interview",
                        stage: .interview
                    )

                    stageButton(
                        "Move to Offer",
                        stage: .offer
                    )

                    stageButton(
                        "Move to Rejected",
                        stage: .rejected
                    )
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.caption)
                        .foregroundStyle(ColorTokens.secondaryText)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Change application stage")
            }
        }
        .padding(Spacing.medium)
        .frame(
            maxWidth: .infinity,
            minHeight: 135,
            alignment: .topLeading
        )
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    ColorTokens.borderGreen,
                    lineWidth: 1
                )
        }
        .shadow(
            color: ColorTokens.primaryGreen.opacity(0.10),
            radius: 2,
            x: 0,
            y: 0
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            stageButton(
                "Move to Applied",
                stage: .applied
            )

            stageButton(
                "Move to Recruiter Screen",
                stage: .recruiterScreen
            )

            stageButton(
                "Move to Interview",
                stage: .interview
            )

            stageButton(
                "Move to Offer",
                stage: .offer
            )

            stageButton(
                "Move to Rejected",
                stage: .rejected
            )
        }
    }

    @ViewBuilder
    private func stageButton(
        _ title: String,
        stage: ApplicationStage
    ) -> some View {
        Button(title) {
            onStageChange(stage)
        }
    }

    private var daysSinceApplied: Int {
        let calendar = Calendar.current
        let days = calendar.dateComponents(
            [.day],
            from: application.appliedDate,
            to: dateProvider.currentDate
        ).day ?? 0
        return max(days, 0)
    }
}