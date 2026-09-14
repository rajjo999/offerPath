import SwiftUI

struct StageColumnView: View {
    let stage: ApplicationStage
    let applications: [JobApplication]
    let onApplicationTap: (JobApplication) -> Void
    let onStageChange: (JobApplication, ApplicationStage) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            // Stage Header
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                HStack {
                    Image(systemName: stage.icon)
                        .font(.system(size: 14))
                    
                    Text(stage.displayName)
                        .font(.headline)
                }
                .foregroundColor(stage.color)
                
                Text("\(applications.count)")
                    .font(.title2)
                    .neonGreenText()
                    .font(.design(.monospaced))
                
                Divider()
                    .overlay(stage.color)
            }
            .padding(.bottom, Spacing.xSmall)
            
            // Applications
            if applications.isEmpty {
                VStack {
                    Text("No applications")
                        .font(.caption)
                        .foregroundColor(ColorTokens.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical)
            } else {
                VStack(spacing: Spacing.xSmall) {
                    ForEach(applications) { application in
                        ApplicationCard(
                            application: application,
                            onTap: { onApplicationTap(application) },
                            onStageChange: { newStage in onStageChange(application, newStage) }
                        )
                    }
                }
            }
        }
        .padding()
        .frame(width: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ColorTokens.borderGreen, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(ColorTokens.surface)
                )
                .shadow(color: ColorTokens.primaryGreen.opacity(0.1), radius: 3, x: 0, y: 0)
        )
    }
}
