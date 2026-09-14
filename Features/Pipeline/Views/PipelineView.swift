import SwiftUI
import SwiftData

struct PipelineView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        sort: \JobApplication.appliedDate,
        order: .reverse
    )
    private var applications: [JobApplication]

    @State private var showAddApplication = false
    @State private var selectedApplication: JobApplication?

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(
                    alignment: .top,
                    spacing: Spacing.medium
                ) {
                    ForEach(ApplicationStage.allCases) { stage in
                        StageColumnView(
                            stage: stage,
                            applications: applications(for: stage),
                            onApplicationTap: { application in
                                selectedApplication = application
                            },
                            onStageChange: { application, newStage in
                                moveApplication(
                                    application,
                                    to: newStage
                                )
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, Spacing.small)
            }
        }
        .background(
            ColorTokens.background.ignoresSafeArea()
        )
        .sheet(isPresented: $showAddApplication) {
            NavigationStack {
                AddApplicationView(
                    viewModel: AddApplicationViewModel(
                        repository: ApplicationRepository(
                            modelContext: modelContext
                        )
                    )
                )
            }
        }
        .sheet(item: $selectedApplication) { application in
            NavigationStack {
                ApplicationDetailView(application: application)
            }
        }
    }

    private var header: some View {
        HStack {
            Text("APPLICATION PIPELINE")
                .font(
                    .system(
                        size: 18,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)
                .shadow(
                    color: ColorTokens.primaryGreen.opacity(0.30),
                    radius: 4,
                    x: 0,
                    y: 0
                )

            Spacer()

            Button {
                showAddApplication = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(ColorTokens.primaryGreen)
                    .frame(width: 44, height: 44)
                    .background(ColorTokens.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                ColorTokens.borderGreen,
                                lineWidth: 1
                            )
                    }
            }
            .accessibilityLabel("Add job application")
        }
        .padding()
    }

    private func applications(
        for stage: ApplicationStage
    ) -> [JobApplication] {
        applications.filter { application in
            application.stage == stage
        }
    }

    private func moveApplication(
        _ application: JobApplication,
        to newStage: ApplicationStage
    ) {
        application.stage = newStage

        do {
            try modelContext.save()
        } catch {
            print(
                "Unable to update application stage: \(error)"
            )
        }
    }
}
