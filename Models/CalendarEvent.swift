import Foundation
import EventKit

enum CalendarEventType: String, Codable, CaseIterable {
    case interview = "Interview"
    case recruiterCall = "Recruiter Call"
    case networking = "Networking"
    case followUp = "Follow-up"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .interview: return "person.2.wave.2"
        case .recruiterCall: return "phone"
        case .networking: return "person.3"
        case .followUp: return "arrow.uturn.backward"
        case .other: return "ellipsis"
        }
    }
    
    var color: Color {
        switch self {
        case .interview: return ColorTokens.primaryGreen
        case .recruiterCall: return ColorTokens.highlightGreen
        case .networking: return ColorTokens.warning
        case .followUp: return ColorTokens.dimGreen
        case .other: return ColorTokens.secondaryText
        }
    }
}

@Model
final class StoredCalendarEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var eventType: CalendarEventType
    var notes: String
    var isAllDay: Bool
    var sourceIdentifier: String? // For linking back to original calendar event
    
    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        endDate: Date,
        eventType: CalendarEventType,
        notes: String = "",
        isAllDay: Bool = false,
        sourceIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.eventType = eventType
        self.notes = notes
        self.isAllDay = isAllDay
        self.sourceIdentifier = sourceIdentifier
    }
}
