import SwiftUI
import SwiftData

struct WeeklyDashboardView: View {
    @Query(
        sort: \JobApplication.appliedDate,
        order: .reverse
    )
    private var applications: [JobApplication]

    private var applicationsThisWeek: [JobApplication] {
        let calendar = Calendar.current

        guard let interval = calendar.dateInterval(
            of: .weekOfYear,
            for: Date()
        ) else {
            return []
        }

        return applications.filter { application in
            application.appliedDate >= interval.start &&
            application.appliedDate < interval.end
        }
    }

    private var interviewCount: Int {
        applicationsThisWeek.filter { application in
            application.stage == .interview
        }.count
    }

    private var followUpCount: Int {
        applicationsThisWeek.filter { application in
            application.followUpDate != nil
        }.count
    }

    private var responseRate: Int {
        let total = applicationsThisWeek.count

        guard total > 0 else {
            return 0
        }

        let responseCount = applicationsThisWeek.filter { application in
            application.stage != .saved &&
            application.stage != .applied
        }.count

        return Int(
            (Double(responseCount) / Double(total)) * 100
        )
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                headerSection
                metricsSection
                coachSection
                trendSection
            }
            .padding(.vertical)
        }
        .background(
            ColorTokens.background.ignoresSafeArea()
        )
        .preferredColorScheme(.dark)
    }

    private var headerSection: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text("WEEKLY INSIGHTS")
                .font(
                    .system(
                        size: 24,
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

            Text("JOB SEARCH ACTIVITY")
                .font(
                    .system(
                        size: 12,
                        weight: .medium,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.secondaryText)
        }
        .padding(.horizontal)
    }

    private var metricsSection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 12
        ) {
            metricCard(
                title: "APPLICATIONS",
                value: String(applicationsThisWeek.count),
                icon: "doc.text"
            )

            metricCard(
                title: "INTERVIEWS",
                value: String(interviewCount),
                icon: "person.2"
            )

            metricCard(
                title: "FOLLOW-UPS",
                value: String(followUpCount),
                icon: "paperplane"
            )

            metricCard(
                title: "RESPONSE RATE",
                value: String(responseRate) + "%",
                icon: "percent"
            )
        }
        .padding(.horizontal)
    }

    private var coachSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            HStack(spacing: 8) {
                Image(systemName: "brain.head.profile")
                    .foregroundStyle(ColorTokens.primaryGreen)

                Text("AI COACH")
                    .font(
                        .system(
                            size: 14,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.primaryGreen)
            }

            Text(
                "Keep your pipeline updated after every recruiter call and interview. Accurate stages make your weekly insights more useful."
            )
            .font(.body)
            .foregroundStyle(ColorTokens.highlightGreen)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    ColorTokens.borderGreen,
                    lineWidth: 1
                )
        }
        .padding(.horizontal)
    }

    private var trendSection: some View {
        VStack(
            alignment: .leading,
            spacing: 12
        ) {
            Text("APPLICATION TREND")
                .font(
                    .system(
                        size: 14,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)

            HStack(
                alignment: .bottom,
                spacing: 12
            ) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(ColorTokens.primaryGreen)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 50,
                        maxHeight: 50
                    )

                RoundedRectangle(cornerRadius: 4)
                    .fill(ColorTokens.primaryGreen)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 80,
                        maxHeight: 80
                    )

                RoundedRectangle(cornerRadius: 4)
                    .fill(ColorTokens.primaryGreen)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 110,
                        maxHeight: 110
                    )

                RoundedRectangle(cornerRadius: 4)
                    .fill(ColorTokens.primaryGreen)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 140,
                        maxHeight: 140
                    )
            }
            .frame(
                maxWidth: .infinity,
                minHeight: 160,
                alignment: .bottom
            )
            .padding()
            .background(ColorTokens.surface)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        ColorTokens.borderGreen,
                        lineWidth: 1
                    )
            }
        }
        .padding(.horizontal)
    }

    private func metricCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Image(systemName: icon)
                .foregroundStyle(ColorTokens.primaryGreen)

            Text(title)
                .font(
                    .system(
                        size: 10,
                        weight: .medium,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.secondaryText)

            Text(value)
                .font(
                    .system(
                        size: 26,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.highlightGreen)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding()
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    ColorTokens.borderGreen,
                    lineWidth: 1
                )
        }
    }
}
