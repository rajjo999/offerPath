import SwiftUI

struct PipelineView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PipelineViewModel
    
    init() {
        let repo = ApplicationRepository(modelContext: ModelContext.shared)
        self._viewModel = StateObject(wrappedValue: PipelineViewModel(repository: repo))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HSTACK {
                Text("Application Pipeline")
                    .font(.title2)
                    .neonGreenText()
                
                Spacer()
                
                Button(action: { viewModel.showAddApplication = true }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(ColorTokens.primaryGreen)
                }
            }
            .padding()
            
            // Pipeline Columns
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.medium) {
                    ForEach(ApplicationStage.allCases, id: \.self) { stage in
                        StageColumnView(
                            stage: stage,
                            applications: viewModel.applications(byStage: stage),
                            onApplicationTap: { application in
                                viewModel.selectedApplication = application
                                viewModel.showDetail = true
                            },
                            onStageChange: { application, newStage in
                                viewModel.moveApplication(application, to: newStage)
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, Spacing.small)
        }
        .background(ColorTokens.background.ignoresSafeArea())
        .sheet(isPresented: $viewModel.showAddApplication) {
            AddApplicationView(viewModel: AddApplicationViewModel(repository: ApplicationRepository(modelContext: ModelContext.shared)))
        }
        .sheet(isPresented: $viewModel.showDetail, item: $viewModel.selectedApplication) { application in
            NavigationStack {
                ApplicationDetailView(application: application)
                    .environment(\.modelContext, modelContext)
            }
        }
    }
}

// MARK: - ViewModel
final class PipelineViewModel: ObservableObject {
    @Published var applications: [JobApplication] = []
    @Published var showAddApplication = false
    @Published var showDetail = false
    @Published var selectedApplication: JobApplication?
    
    private let repository: ApplicationRepositoryProtocol
    
    init(repository: ApplicationRepositoryProtocol) {
        self.repository = repository
        loadApplications()
    }
    
    func loadApplications() {
        applications = repository.fetchApplications()
    }
    
    func applications(byStage stage: ApplicationStage) -> [JobApplication] {
        repository.fetchApplications(byStage: stage)
    }
    
    func moveApplication(_ application: JobApplication, to newStage: ApplicationStage) {
        var updatedApp = application
        updatedApp.stage = newStage
        repository.updateApplication(updatedApp)
        loadApplications()
    }
    
    func addApplication(_ application: JobApplication) {
        repository.saveApplication(application)
        loadApplications()
    }
}
