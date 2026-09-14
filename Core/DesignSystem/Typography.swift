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
}
