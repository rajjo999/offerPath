import Foundation
import SwiftData

enum PreviewData {

    static let modelContainer: ModelContainer = {
        let schema = Schema([
            JobApplication.self,
            StoredCalendarEvent.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError(
                "Could not create preview ModelContainer: \(error)"
            )
        }
    }()

    static let sampleApplications: [JobApplication] = [
        JobApplication(
            company: "Apple Inc.",
            position: "Senior iOS Engineer",
            stage: .applied,
            appliedDate: date(daysFromNow: -2),
            notes: "Applied through Apple Careers. Referral from an internal employee.",
            jobDescription: "Build innovative iOS features and collaborate with product and design teams.",
            salaryRange: "$160k - $200k",
            location: "Cupertino, CA · Hybrid",
            followUpDate: date(daysFromNow: 3),
            interviewDate: date(daysFromNow: 7),
            recruiterName: "Sarah Chen",
            recruiterEmail: "s.chen@apple.com",
            resumeVersion: "v2.1",
            coverLetterVersion: "v1.5"
        ),

        JobApplication(
            company: "Google",
            position: "Mobile Software Engineer",
            stage: .recruiterScreen,
            appliedDate: date(daysFromNow: -5),
            notes: "Recruiter reached out. Phone screen is scheduled.",
            jobDescription: "Build next-generation mobile features used by people worldwide.",
            salaryRange: "$140k - $180k",
            location: "Mountain View, CA · Hybrid",
            followUpDate: date(daysFromNow: 1),
            interviewDate: date(daysFromNow: 4),
            recruiterName: "Marcus Rodriguez",
            recruiterEmail: "m.rodriguez@google.com",
            resumeVersion: "v1.8",
            coverLetterVersion: "v1.2"
        ),

        JobApplication(
            company: "Shopify",
            position: "iOS Developer",
            stage: .interview,
            appliedDate: date(daysFromNow: -12),
            notes: "Technical interview completed. Waiting for the system-design round.",
            jobDescription: "Build commerce tools and mobile experiences for entrepreneurs.",
            salaryRange: "$130k - $160k",
            location: "Remote · Canada",
            followUpDate: date(daysFromNow: 1),
            interviewDate: date(daysFromNow: 2),
            recruiterName: "Emily Wong",
            recruiterEmail: "e.wong@shopify.com",
            resumeVersion: "v2.0",
            coverLetterVersion: "v1.0"
        ),

        JobApplication(
            company: "Netflix",
            position: "Senior iOS Engineer",
            stage: .offer,
            appliedDate: date(daysFromNow: -25),
            notes: "Received an offer. Negotiating equity and signing bonus.",
            jobDescription: "Build premium mobile features for a global streaming product.",
            salaryRange: "$180k - $220k + equity",
            location: "Los Gatos, CA · Remote",
            followUpDate: nil,
            interviewDate: date(daysFromNow: -10),
            recruiterName: "David Kim",
            recruiterEmail: "d.kim@netflix.com",
            resumeVersion: "v3.0",
            coverLetterVersion: "v2.0"
        ),

        JobApplication(
            company: "StartupXYZ",
            position: "Full Stack Engineer",
            stage: .rejected,
            appliedDate: date(daysFromNow: -30),
            notes: "Position was filled internally. Apply again for future openings.",
            jobDescription: "Early-stage fintech startup seeking a versatile full-stack engineer.",
            salaryRange: "$100k - $130k",
            location: "Toronto, ON · Hybrid",
            followUpDate: nil,
            interviewDate: date(daysFromNow: -20),
            recruiterName: "Lisa Patel",
            recruiterEmail: "l.patel@startupxyz.com",
            resumeVersion: "v1.5",
            coverLetterVersion: "v1.0"
        )
    ]

    static let sampleCalendarEvents: [StoredCalendarEvent] = [
        StoredCalendarEvent(
            eventIdentifier: "apple_interview_001",
            title: "Technical Interview · Apple",
            startDate: date(daysFromNow: 4),
            endDate: date(daysFromNow: 4, addingMinutes: 90),
            calendarName: "OfferPath",
            location: "Video call",
            notes: "Whiteboard coding and system-design discussion.",
            eventType: .interview
        ),

        StoredCalendarEvent(
            eventIdentifier: "google_followup_002",
            title: "Follow-up · Marcus at Google",
            startDate: date(daysFromNow: 1),
            endDate: date(daysFromNow: 1, addingMinutes: 30),
            calendarName: "OfferPath",
            location: nil,
            notes: "Check recruiter feedback and next steps.",
            eventType: .followUp
        ),

        StoredCalendarEvent(
            eventIdentifier: "shopify_interview_003",
            title: "System Design Round · Shopify",
            startDate: date(daysFromNow: 2),
            endDate: date(daysFromNow: 2, addingMinutes: 90),
            calendarName: "OfferPath",
            location: "Google Meet",
            notes: "Architecture discussion for a commerce platform.",
            eventType: .interview
        ),

        StoredCalendarEvent(
            eventIdentifier: "toronto_meetup_004",
            title: "Networking · Toronto iOS Meetup",
            startDate: date(daysFromNow: 3),
            endDate: date(daysFromNow: 3, addingMinutes: 90),
            calendarName: "Personal",
            location: "Toronto, ON",
            notes: "Monthly meetup for iOS developers.",
            eventType: .networking
        )
    ]

    @MainActor
    static func makePreviewContainerWithSampleData() -> ModelContainer {
        let container = modelContainer
        let context = container.mainContext

        for application in sampleApplications {
            context.insert(application)
        }

        for event in sampleCalendarEvents {
            context.insert(event)
        }

        do {
            try context.save()
        } catch {
            print("Failed to insert preview data: \(error)")
        }

        return container
    }

    private static func date(
        daysFromNow: Int,
        addingMinutes minutes: Int = 0
    ) -> Date {
        let startOfToday = Calendar.current.startOfDay(for: Date())

        let dayDate = Calendar.current.date(
            byAdding: .day,
            value: daysFromNow,
            to: startOfToday
        ) ?? Date()

        return Calendar.current.date(
            byAdding: .minute,
            value: minutes,
            to: dayDate
        ) ?? dayDate
    }
}
