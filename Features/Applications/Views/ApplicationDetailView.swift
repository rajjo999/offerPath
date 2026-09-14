import SwiftUI
import SwiftData

struct ApplicationDetailView: View {
    let application: JobApplication

    var body: some View {
        ApplicationDetailContent(application: application)
    }
}

private struct ApplicationDetailContent: View {
    let application: JobApplication

    @Environment(\.modelContext)
    private var modelContext

    @Environment(\.dismiss)
    private var dismiss

    @StateObject
    private var viewModel: ApplicationDetailViewModel

    init(application: JobApplication) {
        self.application = application

        _viewModel = StateObject(
            wrappedValue: ApplicationDetailViewModel(
                application: application
            )
        )
    }

    var body: some View {
        List {
            positionSection
            detailsSection
            stageSection
            datesSection
            contactSection
            documentsSection
            notesSection
        }
        .navigationTitle("APPLICATION DETAILS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .destructiveAction) {
                Button("Delete", role: .destructive) {
                    viewModel.showingDeleteConfirm = true
                }
            }
        }
        .alert(
            "DELETE APPLICATION",
            isPresented: $viewModel.showingDeleteConfirm
        ) {
            Button("Cancel", role: .cancel) {
                viewModel.showingDeleteConfirm = false
            }

            Button("Delete", role: .destructive) {
                viewModel.deleteApplication(
                    using: modelContext
                )
                dismiss()
            }
        } message: {
            Text(
                "Are you sure you want to delete this application? This action cannot be undone."
            )
        }
    }

    private var positionSection: some View {
        Section("POSITION & COMPANY") {
            LabeledContent(
                "Position",
                value: application.position
            )

            LabeledContent(
                "Company",
                value: application.company
            )
        }
    }

    private var detailsSection: some View {
        Section("DETAILS") {
            if let location = application.location,
               !location.isEmpty {
                LabeledContent(
                    "Location",
                    value: location
                )
            }

            if let salaryRange = application.salaryRange,
               !salaryRange.isEmpty {
                LabeledContent(
                    "Salary Range",
                    value: salaryRange
                )
            }

            LabeledContent(
                "Applied",
                value: application.appliedDate,
                format: .dateTime
                    .month(.abbreviated)
                    .day()
                    .year()
            )
        }
    }

    private var stageSection: some View {
        Section("STAGE & PROGRESS") {
            VStack(
                alignment: .leading,
                spacing: 8
            ) {
                HStack {
                    Text(application.stage.displayName)
                        .font(
                            .system(
                                size: 14,
                                weight: .bold,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(application.stage.color)

                    Spacer()

                    Text(daysSinceAppliedText)
                        .font(
                            .system(
                                size: 11,
                                weight: .medium,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(
                            ColorTokens.secondaryText
                        )
                }

                ProgressView(
                    value: application.stage.progress
                )
                .tint(application.stage.color)
            }

            Picker(
                "Update Stage",
                selection: $viewModel.selectedStage
            ) {
                ForEach(
                    ApplicationStage.allCases
                ) { stage in
                    Text(stage.displayName)
                        .tag(stage)
                }
            }
            .pickerStyle(.menu)

            Button("UPDATE STAGE") {
                viewModel.updateStage(
                    using: modelContext
                )
            }
            .buttonStyle(.borderedProminent)
            .tint(ColorTokens.primaryGreen)
            .disabled(
                viewModel.selectedStage == application.stage
            )
        }
    }

    private var datesSection: some View {
        Section("DATES") {
            if let followUpDate = application.followUpDate {
                LabeledContent(
                    "Follow-up",
                    value: followUpDate,
                    format: .dateTime
                        .month(.abbreviated)
                        .day()
                        .year()
                        .hour()
                        .minute()
                )
            }

            if let interviewDate = application.interviewDate {
                LabeledContent(
                    "Interview",
                    value: interviewDate,
                    format: .dateTime
                        .month(.abbreviated)
                        .day()
                        .year()
                        .hour()
                        .minute()
                )
            }

            if application.followUpDate == nil &&
                application.interviewDate == nil {
                Text("No dates scheduled")
                    .foregroundStyle(
                        ColorTokens.secondaryText
                    )
            }
        }
    }

    private var contactSection: some View {
        Section("CONTACT") {
            if let recruiterName = application.recruiterName,
               !recruiterName.isEmpty {
                LabeledContent(
                    "Recruiter",
                    value: recruiterName
                )
            }

            if let recruiterEmail = application.recruiterEmail,
               !recruiterEmail.isEmpty {
                LabeledContent(
                    "Email",
                    value: recruiterEmail
                )
            }

            let hasRecruiterName = !(
                application.recruiterName?.isEmpty ?? true
            )

            let hasRecruiterEmail = !(
                application.recruiterEmail?.isEmpty ?? true
            )

            if !hasRecruiterName &&
                !hasRecruiterEmail {
                Text("No recruiter information")
                    .foregroundStyle(
                        ColorTokens.secondaryText
                    )
            }
        }
    }

    private var documentsSection: some View {
        Section("DOCUMENTS") {
            if let resumeVersion = application.resumeVersion,
               !resumeVersion.isEmpty {
                LabeledContent(
                    "Resume Version",
                    value: resumeVersion
                )
            }

            if let coverLetterVersion = application.coverLetterVersion,
               !coverLetterVersion.isEmpty {
                LabeledContent(
                    "Cover Letter Version",
                    value: coverLetterVersion
                )
            }

            let hasResumeVersion = !(
                application.resumeVersion?.isEmpty ?? true
            )

            let hasCoverLetterVersion = !(
                application.coverLetterVersion?.isEmpty ?? true
            )

            if !hasResumeVersion &&
                !hasCoverLetterVersion {
                Text("No documents recorded")
                    .foregroundStyle(
                        ColorTokens.secondaryText
                    )
            }
        }
    }

    private var notesSection: some View {
        Section("NOTES") {
            Text(
                application.notes.isEmpty
                ? "No notes added"
                : application.notes
            )
            .foregroundStyle(
                application.notes.isEmpty
                ? ColorTokens.secondaryText
                : Color.primary
            )
        }
    }

    private var daysSinceAppliedText: String {
        let components = Calendar.current.dateComponents(
            [.day],
            from: application.appliedDate,
            to: Date()
        )

        let days = components.day ?? 0

        return "\(max(days, 0)) DAYS AGO"
    }
}

@MainActor
final class ApplicationDetailViewModel: ObservableObject {
    @Published var selectedStage: ApplicationStage
    @Published var showingDeleteConfirm = false

    private let application: JobApplication

    init(application: JobApplication) {
        self.application = application
        self.selectedStage = application.stage
    }

    func updateStage(using modelContext: ModelContext) {
        application.stage = selectedStage

        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to update application stage: \(error)"
            )
        }
    }

    func deleteApplication(using modelContext: ModelContext) {
        modelContext.delete(application)

        do {
            try modelContext.save()
        } catch {
            print(
                "Failed to delete application: \(error)"
            )
        }
    }
}
