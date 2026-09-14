import SwiftUI

extension View {
    func neonGreenText() -> some View {
        self.foregroundColor(ColorTokens.primaryGreen)
    }
    
    func neonGreenBackground() -> some View {
        self.background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(ColorTokens.borderGreen, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(ColorTokens.surface)
                )
                .shadow(color: ColorTokens.primaryGreen.opacity(0.2), radius: 2, x: 0, y: 0)
        )
    }
    
    func dashboardCardStyle() -> some View {
        self.padding(Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(ColorTokens.borderGreen, lineWidth: 1)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(ColorTokens.surface)
                    )
                    .shadow(color: ColorTokens.primaryGreen.opacity(0.15), radius: 3, x: 0, y: 0)
            )
    }
    
    func stageTag(stage: ApplicationStage) -> some View {
        self.padding(.horizontal, Spacing.xSmall)
            .padding(.vertical, Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(stage.color.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(stage.color, lineWidth: 1)
            )
            .foregroundColor(stage.color)
            .font(Typography.digitalFont)
    }
}
