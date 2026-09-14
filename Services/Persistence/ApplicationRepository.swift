import Foundation
import SwiftData

protocol ApplicationRepositoryProtocol {
    func fetchApplications() -> [JobApplication]
    func fetchApplications(
        byStage stage: ApplicationStage
    ) -> [JobApplication]
    func saveApplication(_ application: JobApplication)
    func updateApplication(_ application: JobApplication)
    func deleteApplication(_ application: JobApplication)
    func applicationCount() -> Int
    func countByStage(_ stage: ApplicationStage) -> Int
}

@MainActor
final class ApplicationRepository:
    ApplicationRepositoryProtocol
{
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchApplications() -> [JobApplication] {
        let descriptor = FetchDescriptor<JobApplication>(
            sortBy: [
                SortDescriptor<JobApplication>(
                    \.appliedDate,
                    order: .reverse
                )
            ]
        )

        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch applications: \(error)")
            return []
        }
    }

    func fetchApplications(
        byStage stage: ApplicationStage
    ) -> [JobApplication] {
        let descriptor = FetchDescriptor<JobApplication>(
            sortBy: [
                SortDescriptor<JobApplication>(
                    \.appliedDate,
                    order: .reverse
                )
            ]
        )

        do {
            let applications = try modelContext.fetch(descriptor)

            return applications.filter { application in
                application.stage == stage
            }
        } catch {
            print(
                "Failed to fetch applications by stage: \(error)"
            )
            return []
        }
    }

    func saveApplication(_ application: JobApplication) {
        modelContext.insert(application)
        saveContext()
    }

    func updateApplication(_ application: JobApplication) {
        saveContext()
    }

    func deleteApplication(_ application: JobApplication) {
        modelContext.delete(application)
        saveContext()
    }

    func applicationCount() -> Int {
        let descriptor = FetchDescriptor<JobApplication>()

        do {
            return try modelContext.fetchCount(descriptor)
        } catch {
            print("Failed to count applications: \(error)")
            return 0
        }
    }

    func countByStage(_ stage: ApplicationStage) -> Int {
        let descriptor = FetchDescriptor<JobApplication>()

        do {
            let applications = try modelContext.fetch(descriptor)

            return applications.filter { application in
                application.stage == stage
            }.count
        } catch {
            print(
                "Failed to count applications by stage: \(error)"
            )
            return 0
        }
    }

    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save application context: \(error)")
        }
    }
}
