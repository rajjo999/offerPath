import Foundation
import SwiftData

enum PreviewData {
    static let modelContainer: ModelContainer = {
        let schema = Schema([
            JobApplication.self,
            StoredCalendarEvent.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static let sampleApplications: [JobApplication] = [
        JobApplication(
            company: "Apple Inc.",
            position: "Senior iOS Engineer",
            stage: .applied,
            appliedDate: Date().addingTimeInterval(-86400 * 2),
            notes: "Applied through Apple Careers site. Referral from internal employee.",
            jobDescription: "We are looking for a passionate iOS engineer to work on innovative features for iOS 18 and beyond...",
            salaryRange: "$160k - $200k",
            location: "Cupertino, CA (Hybrid)",
            followUpDate: Date().addingTimeInterval(86400 * 3),
            interviewDate: Date().addingTimeInterval(86400 * 7),
            recruiterName: "Sarah Chen",
            recruiterEmail: "s.chen@apple.com",
            resumeVersion: "v2.1",
            coverLetterVersion: "v1.5"
        ),
        JobApplication(
            company: "Google",
            position: "Mobile Software Engineer",
            stage: .recruiterScreen,
            appliedDate: Date().addingTimeInterval(-86400 * 5),
            notes: "Recruiter reached out via LinkedIn. Phone screen scheduled.",
            jobDescription: "Join our Android team to build next-generation features for billions of users...",
            salaryRange: "$140k - $180k",
            location: "Mountain View, CA (Hybrid)",
            followUpDate: Date().addingTimeInterval(86400),
            interviewDate: Date().addingTimeInterval(86400 * 4),
            recruiterName: "Marcus Rodriguez",
            recruiterEmail: "m.rodriguez@google.com",
            resumeVersion: "v1.8",
            coverLetterVersion: "v1.2"
        ),
        JobApplication(
            company: "Shopify",
            position: "iOS Developer",
            stage: .interview,
            appliedDate: Date().addingTimeInterval(-86400 * 12),
            notes: "Technical interview completed. Waiting for system design round.",
            jobDescription: "Help entrepreneurs succeed by building commerce tools for iOS merchants...",
            salaryRange: "$130k - $160k",
            location: "Remote (Canada)",
            followUpDate: Date().addingTimeInterval(86400),
            interviewDate: Date().addingTimeInterval(86400 * 2),
            recruiterName: "Emily Wong",
            recruiterEmail: "e.wong@shopify.com",
            resumeVersion: "v2.0",
            coverLetterVersion: "v1.0"
        ),
        JobApplication(
            company: "Netflix",
            position: "Senior iOS Engineer",
            stage: .offer,
            appliedDate: Date().addingTimeInterval(-86400 * 25),
            notes: "Received offer! Negotiating equity and signing bonus.",
            jobDescription: "Build features for the Netflix iOS app used by millions of subscribers daily...",
            salaryRange: "$180k - $220k + 0.05% equity",
            location: "Los Gatos, CA (Remote)",
            interviewDate: Date().addingTimeInterval(-86400 * 10),
            recruiterName: "David Kim",
            recruiterEmail: "d.kim@netflix.com",
            resumeVersion: "v3.0",
            coverLetterVersion: "v2.0"
        ),
        JobApplication(
            company: "StartupXYZ",
            position: "Full Stack Engineer",
            stage: .rejected,
            appliedDate: Date().addingTimeInterval(-86400 * 30),
            notes: "Position filled internally. Encouraged to apply for future openings.",
            jobDescription: "Early-stage fintech startup looking for versatile full-stack engineer...",
            salaryRange: "$100k - $130k",
            location: "Toronto, ON (Hybrid)",
            interviewDate: Date().addingTimeInterval(-86400 * 20),
            recruiterName: "Lisa Patel",
            recruiterEmail: "l.patel@startupxyz.com",
            resumeVersion: "v1.5",
            coverLetterVersion: "v1.0"
        )
    ]
    
    static let sampleCalendarEvents: [StoredCalendarEvent] = [
        StoredCalendarEvent(
            title: "Technical Interview - Apple",
            startDate: Date().addingTimeInterval(86400 * 4),
            endDate: Date().addingTimeInterval(86400 * 4.5),
            eventType: .interview,
            notes: "Whiteboard coding + system design discussion",
            sourceIdentifier: "apple_interview_001"
        ),
        StoredCalendarEvent(
            title: "Follow-up with Marcus - Google",
            startDate: Date().addingTimeInterval(86400),
            endDate: Date().addingTimeInterval(86400 + 1800),
            eventType: .followUp,
            notes: "Check on recruiter feedback and next steps",
            sourceIdentifier: "google_followup_002"
        ),
        StoredCalendarEvent(
            title: "System Design Round - Shopify",
            startDate: Date().addingTimeInterval(86400 * 2),
            endDate: Date().addingTimeInterval(86400 * 2.5),
            eventType: .interview,
            notes: "Architecture discussion for commerce platform",
            sourceIdentifier: "shopify_interview_003"
        ),
        StoredCalendarEvent(
            title: "Networking - Toronto iOS Meetup",
            startDate: Date().addingTimeInterval(86400 * 3),
            endDate: Date().addingTimeInterval(86400 * 3.5),
            eventType: .networking,
            notes: "Monthly meetup for iOS developers in Toronto",
            sourceIdentifier: "toronto_meetup_004"
        )
    ]
}
