import Foundation
import SwiftData

enum JobEventType: String, Codable, CaseIterable, Identifiable {
    case interview = "Interview"
    case recruiterCall = "Recruiter Call"
    case networking = "Networking"
    case followUp = "Follow-up"
    case other = "Other"

    var id: String {
        rawValue
    }
}

@Model
final class StoredCalendarEvent {
    var eventIdentifier: String
    var title: String
    var startDate: Date
    var endDate: Date
    var calendarName: String
    var location: String?
    var notes: String?
    var eventTypeRawValue: String

    init(
        eventIdentifier: String,
        title: String,
        startDate: Date,
        endDate: Date,
        calendarName: String,
        location: String? = nil,
        notes: String? = nil,
        eventType: JobEventType = .other
    ) {
        self.eventIdentifier = eventIdentifier
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.calendarName = calendarName
        self.location = location
        self.notes = notes
        self.eventTypeRawValue = eventType.rawValue
    }

    var eventType: JobEventType {
        get {
            JobEventType(rawValue: eventTypeRawValue) ?? .other
        }
        set {
            eventTypeRawValue = newValue.rawValue
        }
    }
}
