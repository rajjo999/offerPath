import SwiftUI

struct ApplicationCard: View {
    let application: JobApplication
    let onTap: () -> Void
    let onStageChange: (ApplicationStage) -> Void
    
    @State private var showingMenu = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            // Company & Position
            VStack(alignment: .leading, spacing: Spacing.xxxSmall) {
                Text(application.position)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text(application.company)
                    .font(.caption)
                    .foregroundColor(ColorTokens.secondaryText)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 4)
            
            // Stage Tags
            HSTACK(spacing: Spacing.xSmall) {
                Text(application.stage.displayName)
                    .font(.caption2)
                    .stageTag(style: application.stage)
                
                if let days = application.daysSinceApplied {
                    Text("\(days)d")
                        .font(.caption2)
                        .foregroundColor(ColorTokens.secondaryText)
                }
            }
            
            Spacer()
            
            // Action Buttons
            HSTACK {
                Button(action: { onTap() }) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(ColorTokens.primaryGreen)
                }
                
                Spacer()
                
                Button(action: { showingMenu = true }) {
                    Image(systemName: "ellipsis.circle")
                        .font(.caption)
                        .foregroundColor(ColorTokens.secondaryText)
                }
            }
        }
        .padding(Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorTokens.borderGreen, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTokens.surface)
                )
                .shadow(color: ColorTokens.primaryGreen.opacity(0.1), radius: 2, x: 0, y: 0)
        )
        .onTapGesture { onTap() }
        .contextMenu {
            Button("Move to Applied") {
                onStageChange(.applied)
            }
            Button("Move to Recruiter Screen") {
                onStageChange(.recruiterScreen)
            }
            Button("Move to Interview") {
                onStageChange(.interview)
            }
            Button("Move to Offer") {
                onStageChange(.offer)
            }
            Button("Move to Rejected", role: .destructive) {
                onStageChange(.rejected)
            }
            Divider()
            Button("Delete Application", role: .destructive) {
                // Would integrate with repository delete
            }
        }
    }
}
