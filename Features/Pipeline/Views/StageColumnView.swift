import SwiftUI

struct StageColumnView: View {
    let stage: ApplicationStage
    let applications: [JobApplication]
    let onApplicationTap: (JobApplication) -> Void
    let onStageChange: (JobApplication, ApplicationStage) -> Void

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.medium
        ) {
            stageHeader

            if applications.isEmpty {
                emptyState
            } else {
                applicationList
            }
        }
        .padding()
        .frame(
            width: 180,
            alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(ColorTokens.surface)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    ColorTokens.borderGreen,
                    lineWidth: 1
                )
        }
        .shadow(
            color: ColorTokens.primaryGreen.opacity(0.10),
            radius: 3,
            x: 0,
            y: 0
        )
    }

    private var stageHeader: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            HStack {
                Image(systemName: stage.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(stage.color)

                Text(stage.displayName)
                    .font(
                        .system(
                            size: 13,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(stage.color)
                    .lineLimit(2)
            }

            Text(String(applications.count))
                .font(
                    .system(
                        size: 24,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)

            Divider()
                .overlay(stage.color)
        }
        .padding(.bottom, Spacing.xSmall)
    }

    private var emptyState: some View {
        Text("NO APPLICATIONS")
            .font(
                .system(
                    size: 10,
                    weight: .medium,
                    design: .monospaced
                )
            )
            .foregroundStyle(ColorTokens.secondaryText)
            .frame(
                maxWidth: .infinity,
                alignment: .center
            )
            .padding(.vertical)
    }

    private var applicationList: some View {
        VStack(spacing: Spacing.xSmall) {
            ForEach(applications) { application in
                ApplicationCard(
                    application: application,
                    onTap: {
                        onApplicationTap(application)
                    },
                    onStageChange: { newStage in
                        onStageChange(
                            application,
                            newStage
                        )
                    }
                )
            }
        }
    }
}
