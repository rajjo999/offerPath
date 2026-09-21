import SwiftUI

struct Typography {
    // Digital/monospace for numbers and labels
    static let digitalFont = Font.system(.body, design: .monospaced)
    static let digitalBold = Font.system(.body, design: .monospaced).weight(.bold)
    
    // Regular font for descriptions and AI text
    static let body = Font.body
    static let bodyBold = Font.body.weight(.semibold)
    static let title2 = Font.title2
    static let title3 = Font.title3
    static let caption = Font.caption
    
    // Specific sizes for OfferPath app
    static let title24 = Font.system(size: 24, weight: .bold, design: .monospaced)
    static let title18 = Font.system(size: 18, weight: .bold, design: .monospaced)
    static let title16 = Font.system(size: 16, weight: .bold, design: .monospaced)
    static let header14 = Font.system(size: 14, weight: .bold, design: .monospaced)
    static let body14 = Font.system(size: 14, weight: .regular, design: .monospaced)
    static let body12 = Font.system(size: 12, weight: .bold, design: .monospaced)
    static let body11 = Font.system(size: 11, weight: .medium, design: .monospaced)
    static let body10 = Font.system(size: 10, weight: .medium, design: .monospaced)
    static let caption9 = Font.system(size: 9, weight: .medium, design: .monospaced)
    static let title26 = Font.system(size: 26, weight: .bold, design: .monospaced)
    static let icon14 = Font.system(size: 14, weight: .regular, design: .monospaced)
    static let icon18 = Font.system(size: 18, weight: .regular, design: .monospaced)
    static let icon20 = Font.system(size: 20, weight: .regular, design: .monospaced)
    static let stageHeaderText = Font.system(size: 13, weight: .semibold, design: .monospaced)
    static let stageCount = Font.system(size: 24, weight: .bold, design: .monospaced)
    static let emptyStateText = Font.system(size: 10, weight: .medium, design: .monospaced)
}