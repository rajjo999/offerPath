import Foundation
import SwiftData

protocol CalendarRepositoryProtocol {
    func fetchEvents() -> [StoredCalendarEvent]
    func fetchEvents(startingAfter date: Date) -> [StoredCalendarEvent]
    func saveEvent(_ event: StoredCalendarEvent)
    func updateEvent(_ event: StoredCalendarEvent)
    func deleteEvent(_ event: StoredCalendarEvent)
    func eventCount() -> Int
}

final class CalendarRepository: CalendarRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchEvents() -> [StoredCalendarEvent] {
        let descriptor = FetchDescriptor<StoredCalendarEvent>(
            sortBy: [SortDescriptor(\.startDate)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchEvents(startingAfter date: Date) -> [StoredCalendarEvent] {
        let descriptor = FetchDescriptor<StoredCalendarEvent>(
            predicate: #Predicate { $0.startDate >= date },
            sortBy: [SortDescriptor(\.startDate)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func saveEvent(_ event: StoredCalendarEvent) {
        modelContext.insert(event)
        save()
    }
    
    func updateEvent(_ event: StoredCalendarEvent) {
        save()
    }
    
    func deleteEvent(_ event: StoredCalendarEvent) {
        modelContext.delete(event)
        save()
    }
    
    func eventCount() -> Int {
        (try? modelContext.count(FetchDescriptor<StoredCalendarEvent>())) ?? 0
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save calendar context: \(error)")
        }
    }
}
