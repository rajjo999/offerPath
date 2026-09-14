import Foundation
import SwiftData

@Model
final class JobApplication {
    @Attribute(.unique) var id: UUID
    var company: String
    var position: String
    var stage: ApplicationStage
    var appliedDate: Date
    var notes: String
    var jobDescription: String?
    var salaryRange: String?
    var location: String?
    var followUpDate: Date?
    var interviewDate: Date?
    var recruiterName: String?
    var recruiterEmail: String?
    var resumeVersion: String?
    var coverLetterVersion: String?
    
    // MARK: - Computed Properties
    var daysSinceApplied: Int {
        Calendar.current.dateComponents([.day], from: appliedDate, to: Date()).day ?? 0
    }
    
    var isActive: Bool {
        stage != .offer && stage != .rejected
    }
    
    var daysUntilFollowUp: Int? {
        guard let followUpDate = followUpDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: followUpDate).day
    }
    
    var daysUntilInterview: Int? {
        guard let interviewDate = interviewDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: interviewDate).day
    }
    
    init(
        id: UUID = UUID(),
        company: String,
        position: String,
        stage: ApplicationStage,
        appliedDate: Date = Date(),
        notes: String = "",
        jobDescription: String? = nil,
        salaryRange: String? = nil,
        location: String? = nil,
        followUpDate: Date? = nil,
        interviewDate: Date? = nil,
        recruiterName: String? = nil,
        recruiterEmail: String? = nil,
        resumeVersion: String? = nil,
        coverLetterVersion: String? = nil
    ) {
        self.id = id
        self.company = company
        self.position = position
        self.stage = stage
        self.appliedDate = appliedDate
        self.notes = notes
        self.jobDescription = jobDescription
        self.salaryRange = salaryRange
        self.location = location
        self.followUpDate = followUpDate
        self.interviewDate = interviewDate
        self.recruiterName = recruiterName
        self.recruiterEmail = recruiterEmail
        self.resumeVersion = resumeVersion
        self.coverLetterVersion = coverLetterVersion
    }
}
