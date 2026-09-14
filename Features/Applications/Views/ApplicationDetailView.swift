import SwiftUI

struct ApplicationDetailView: View {
    let application: JobApplication
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ApplicationDetailViewModel
    
    init(application: JobApplication) {
        self.application = application
        self._viewModel = StateObject(wrappedValue: ApplicationDetailViewModel(
            application: application,
            repository: ApplicationRepository(modelContext: ModelContext.shared)
        ))
    }
    
    var body: some View {
        List {
            Section("Position & Company") {
                LabeledContent("Position", value: application.position)
                LabeledContent("Company", value: application.company)
            }
            
            Section("Details") {
                if let location = application.location {
                    LabeledContent("Location", value: location)
                }
                if let salaryRange = application.salaryRange {
                    LabeledContent("Salary Range", value: salaryRange)
                }
                LabeledContent("Applied", value: application.appliedDate, format: .dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
            }
            
            Section("Stage & Progress") {
                VSTACK(alignment: .leading, spacing: 4) {
                    HSTACK {
                        Text(application.stage.displayName)
                            .font(.headline)
                            .stageTag(style: application.stage)
                        
                        Spacer()
                        
                        Text("\(application.daysSinceApplied) days ago")
                            .font(.caption)
                            .foregroundColor(ColorTokens.secondaryText)
                    }
                    
                    ProgressView(value: application.stage.progress)
                        .tint(application.stage.color)
                }
                
                Picker("Update Stage", selection: $viewModel.selectedStage) {
                    ForEach(ApplicationStage.allCases, id: \.self) { stage in
                        Text(stage.displayName).tag(stage)
                    }
                }
                .pickerStyle(.menu)
                
                Button("Update Stage") {
                    viewModel.updateStage()
                }
                .buttonStyle(.borderedProminent)
                .tint(ColorTokens.primaryGreen)
                .disabled(viewModel.selectedStage == application.stage)
            }
            
            Section("Dates") {
                if let followUp = application.followUpDate {
                    LabeledContent("Follow-up", value: followUp, format: .dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
                }
                if let interview = application.interviewDate {
                    LabeledContent("Interview", value: interview, format: .dateTime.month(.defaultDigits).day().year(.twoDigits).hour().minute())
                }
            }
            
            Section("Contact") {
                if let name = application.recruiterName {
                    LabeledContent("Recruiter", value: name)
                }
                if let email = application.recruiterEmail {
                    LabeledContent("Email", value: email)
                }
            }
            
            Section("Documents") {
                if let resume = application.resumeVersion {
                    LabeledContent("Resume Version", value: resume)
                }
                if let letter = application.coverLetterVersion {
                    LabeledContent("Cover Letter Version", value: letter)
                }
            }
            
            Section("Notes") {
                Text(application.notes.isEmpty ? "No notes added" : application.notes)
                    .foregroundColor(application.notes.isEmpty ? ColorTokens.secondaryText : .primary)
            }
        }
        .navigationTitle("Application Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Delete", role: .destructive) {
                    viewModel.deleteApplication()
                    dismiss()
                }
            }
        }
        .alert("Delete Application", isPresented: $viewModel.showingDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this application? This action cannot be undone.")
        }
    }
}

// MARK: - ViewModel
final class ApplicationDetailViewModel: ObservableObject {
    @Published var selectedStage: ApplicationStage
    @Published var showingDeleteConfirm = false
    
    private let application: JobApplication
    private let repository: ApplicationRepositoryProtocol
    
    init(application: JobApplication, repository: ApplicationRepositoryProtocol) {
        self.application = application
        self.repository = repository
        self._selectedStage = Published(initialValue: application.stage)
    }
    
    func updateStage() {
        var updatedApp = application
        updatedApp.stage = selectedStage
        repository.updateApplication(updatedApp)
    }
    
    func deleteApplication() {
        repository.deleteApplication(application)
    }
    
    func confirmDelete() {
        deleteApplication()
    }
}
