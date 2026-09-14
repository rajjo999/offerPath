import Foundation

enum ApplicationStage: String, Codable, CaseIterable {
    case saved = "Saved"
    case applied = "Applied"
    case recruiterScreen = "Recruiter Screen"
    case interview = "Interview"
    case offer = "Offer"
    case rejected = "Rejected"
    
    var displayName: String { rawValue }
    
    var icon: String {
        switch self {
        case .saved: return "bookmark"
        case .applied: return "plus.circle"
        case .recruiterScreen: return "person.crop.circle.badge.questionmark"
        case .interview: return "person.2.wave.2"
        case .offer: return "hand.thumbsup"
        case .rejected: return "xmark.octagon"
        }
    }
    
    var color: Color {
        switch self {
        case .saved: return ColorTokens.secondaryText
        case .applied: return ColorTokens.primaryGreen
        case .recruiterScreen: return ColorTokens.warning
        case .interview: return ColorTokens.highlightGreen
        case .offer: return ColorTokens.dimGreen
        case .rejected: return Color.secondary.opacity(0.6)
        }
    }
    
    var progress: Double {
        switch self {
        case .saved: return 0.0
        case .applied: return 0.2
        case .recruiterScreen: return 0.4
        case .interview: return 0.6
        case .offer: return 0.8
        case .rejected: return 1.0
        }
    }
}
