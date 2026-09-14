import Foundation
import SwiftData

protocol ApplicationRepositoryProtocol {
    func fetchApplications() -> [JobApplication]
    func fetchApplications(byStage stage: ApplicationStage) -> [JobApplication]
    func saveApplication(_ application: JobApplication)
    func updateApplication(_ application: JobApplication)
    func deleteApplication(_ application: JobApplication)
    func applicationCount() -> Int
    func countByStage(_ stage: ApplicationStage) -> Int
}

final class ApplicationRepository: ApplicationRepositoryProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchApplications() -> [JobApplication] {
        let descriptor = FetchDescriptor<JobApplication>(
            sortBy: [SortDescriptor(\.appliedDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchApplications(byStage stage: ApplicationStage) -> [JobApplication] {
        let descriptor = FetchDescriptor<JobApplication>(
            predicate: #Predicate { $0.stage == stage },
            sortBy: [SortDescriptor(\.appliedDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func saveApplication(_ application: JobApplication) {
        modelContext.insert(application)
        save()
    }
    
    func updateApplication(_ application: JobApplication) {
        save()
    }
    
    func deleteApplication(_ application: JobApplication) {
        modelContext.delete(application)
        save()
    }
    
    func applicationCount() -> Int {
        (try? modelContext.count(FetchDescriptor<JobApplication>())) ?? 0
    }
    
    func countByStage(_ stage: ApplicationStage) -> Int {
        let descriptor = FetchDescriptor<JobApplication>(
            predicate: #Predicate { $0.stage == stage }
        )
        return (try? modelContext.count(descriptor)) ?? 0
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
