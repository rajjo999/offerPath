import SwiftUI

struct AddApplicationView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddApplicationViewModel
    
    init(viewModel: AddApplicationViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Position & Company") {
                    TextField("Position", text: $viewModel.position)
                    TextField("Company", text: $viewModel.company)
                }
                
                Section("Details") {
                    TextField("Location (Optional)", text: $viewModel.location)
                    TextField("Salary Range (Optional)", text: $viewModel.salaryRange)
                }
                
                Section("Stage") {
                    Picker("Current Stage", selection: $viewModel.stage) {
                        ForEach(ApplicationStage.allCases, id: \.self) { stage in
                            Text(stage.displayName).tag(stage)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Notes (Optional)") {
                    TextEditor(text: $viewModel.notes)
                        .frame(height: 80)
                }
            }
            .navigationTitle("New Application")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationActionLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationActionTrailing) {
                    Button("Save") {
                        viewModel.saveApplication()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

// MARK: - ViewModel
final class AddApplicationViewModel: ObservableObject {
    @Published var position: String = ""
    @Published var company: String = ""
    @Published var location: String = ""
    @Published var salaryRange: String = ""
    @Published var notes: String = ""
    @Published var stage: ApplicationStage = .applied
    
    private let repository: ApplicationRepositoryProtocol
    
    init(repository: ApplicationRepositoryProtocol) {
        self.repository = repository
    }
    
    var isValid: Bool {
        !position.isEmpty && !company.isEmpty
    }
    
    func saveApplication() {
        let application = JobApplication(
            company: company,
            position: position,
            stage: stage,
            appliedDate: Date(),
            notes: notes,
            location: location.isEmpty ? nil : location,
            salaryRange: salaryRange.isEmpty ? nil : salaryRange
        )
        repository.saveApplication(application)
    }
}
