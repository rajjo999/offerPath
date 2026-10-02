import SwiftUI

struct AddApplicationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddApplicationViewModel

    init(viewModel: AddApplicationViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        Form {
            Section("POSITION & COMPANY") {
                TextField(
                    "Position",
                    text: $viewModel.position
                )

                TextField(
                    "Company",
                    text: $viewModel.company
                )
            }

            Section("DETAILS") {
                TextField(
                    "Salary Range (Optional)",
                    text: $viewModel.salaryRange
                )

                TextField(
                    "Location (Optional)",
                    text: $viewModel.location
                )
            }

            Section("STAGE") {
                Picker(
                    "Current Stage",
                    selection: $viewModel.stage
                ) {
                    ForEach(
                        ApplicationStage.allCases
                    ) { stage in
                        Text(stage.displayName)
                            .tag(stage)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("NOTES (OPTIONAL)") {
                TextEditor(text: $viewModel.notes)
                    .frame(minHeight: 100)
            }
        }
        .navigationTitle("NEW APPLICATION")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.saveApplication()
                    dismiss()
                }
                .disabled(!viewModel.isValid)
            }
        }
    }
}

@MainActor
final class AddApplicationViewModel: ObservableObject {
    @Published var position = ""
    @Published var company = ""
    @Published var location = ""
    @Published var salaryRange = ""
    @Published var notes = ""
    @Published var stage: ApplicationStage = .applied

    private let repository: ApplicationRepositoryProtocol

    init(
        repository: ApplicationRepositoryProtocol,
        initialStage: ApplicationStage = .applied
    ) {
        self.repository = repository
        self.stage = initialStage
    }

    var isValid: Bool {
        !position.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty &&
        !company.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
    }

    func saveApplication() {
        let application = JobApplication(
            company: company.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            position: position.trimmingCharacters(
                in: .whitespacesAndNewlines
            ),
            stage: stage,
            appliedDate: Date(),
            notes: notes,
            jobDescription: "",
            salaryRange: salaryRange,
            location: location,
            followUpDate: nil,
            interviewDate: nil,
            recruiterName: "",
            recruiterEmail: "",
            resumeVersion: "",
            coverLetterVersion: ""
        )

        repository.saveApplication(application)
    }
}
