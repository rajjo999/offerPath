import SwiftUI

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    static let glow = Shadow(
        color: ColorTokens.primaryGreen.opacity(0.3),
        radius: 4,
        x: 0,
        y: 0
    )

    static let subtleGlow = Shadow(
        color: ColorTokens.primaryGreen.opacity(0.15),
        radius: 2,
        x: 0,
        y: 0
    )

    static let innerGlow = Shadow(
        color: ColorTokens.primaryGreen.opacity(0.2),
        radius: 1,
        x: 0,
        y: 0
    )
}
