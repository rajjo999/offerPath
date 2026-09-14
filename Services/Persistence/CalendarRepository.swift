import Foundation
import SwiftData

protocol CalendarRepositoryProtocol {
    func fetchEvents() throws -> [StoredCalendarEvent]
    func fetchEvents(startingAfter date: Date) throws -> [StoredCalendarEvent]
    func saveEvent(_ event: StoredCalendarEvent) throws
    func updateEvent(_ event: StoredCalendarEvent) throws
    func deleteEvent(_ event: StoredCalendarEvent) throws
    func eventCount() throws -> Int
}

@MainActor
final class CalendarRepository: CalendarRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchEvents() throws -> [StoredCalendarEvent] {
        let descriptor = FetchDescriptor<StoredCalendarEvent>(
            sortBy: [
                SortDescriptor<StoredCalendarEvent>(
                    \.startDate,
                    order: .forward
                )
            ]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetchEvents(startingAfter date: Date) throws -> [StoredCalendarEvent] {
        let descriptor = FetchDescriptor<StoredCalendarEvent>(
            sortBy: [
                SortDescriptor<StoredCalendarEvent>(
                    \.startDate,
                    order: .forward
                )
            ]
        )

        let events = try modelContext.fetch(descriptor)

        return events.filter { event in
            event.startDate >= date
        }
    }

    func saveEvent(_ event: StoredCalendarEvent) throws {
        modelContext.insert(event)
        try modelContext.save()
    }

    func updateEvent(_ event: StoredCalendarEvent) throws {
        try modelContext.save()
    }

    func deleteEvent(_ event: StoredCalendarEvent) throws {
        modelContext.delete(event)
        try modelContext.save()
    }

    func eventCount() throws -> Int {
        let descriptor = FetchDescriptor<StoredCalendarEvent>()
        return try modelContext.fetch(descriptor).count
    }
}
