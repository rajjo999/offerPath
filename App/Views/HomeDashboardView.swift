import SwiftUI
import SwiftData

struct HomeDashboardView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var showAddApplication = false
    @State private var presetStage: ApplicationStage = .applied

    @Query(
        sort: \JobApplication.appliedDate,
        order: .reverse
    )
    private var applications: [JobApplication]

    @Query(
        sort: \StoredCalendarEvent.startDate,
        order: .forward
    )
    private var calendarEvents: [StoredCalendarEvent]

    private var todayEvents: [StoredCalendarEvent] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())

        guard let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: todayStart
        ) else {
            return []
        }

        return calendarEvents.filter { event in
            event.startDate >= todayStart &&
            event.startDate < tomorrow
        }
    }

    private var upcomingEvents: [StoredCalendarEvent] {
        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())

        guard let thirtyDaysLater = calendar.date(
            byAdding: .day,
            value: 30,
            to: todayStart
        ) else {
            return []
        }

        return calendarEvents.filter { event in
            event.startDate >= todayStart &&
            event.startDate <= thirtyDaysLater
        }
    }

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
        applications.filter { application in
            application.stage == .interview
        }.count
    }

    private var activeFollowUpCount: Int {
        let now = Date()

        return applications.filter { application in
            guard let followUpDate = application.followUpDate else {
                return false
            }

            return followUpDate > now
        }.count
    }

    private var offerCount: Int {
        applications.filter { application in
            application.stage == .offer
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: Spacing.large
            ) {
                headerSection
                statsSection
                todayScheduleSection
                quickAddSection
            }
            .padding(.vertical)
        }
        .background(
            ColorTokens.background
                .ignoresSafeArea()
        )
        .sheet(isPresented: $showAddApplication) {
            NavigationStack {
                AddApplicationView(
                    viewModel: AddApplicationViewModel(
                        repository: ApplicationRepository(
                            modelContext: modelContext
                        ),
                        initialStage: presetStage
                    )
                )
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: Spacing.xSmall
            ) {
                Text("OFFERPATH")
                    .font(
                        .system(
                            size: 24,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.primaryGreen)

                Text("JOB APPLICATION TRACKER")
                    .font(
                        .system(
                            size: 11,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
            }

            Spacer()

            Button {
                presetStage = .applied
                showAddApplication = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(ColorTokens.primaryGreen)
            }
            .accessibilityLabel("Add job application")
        }
        .padding(.horizontal, Spacing.large)
        .padding(.vertical, Spacing.medium)
    }

    private var statsSection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: Spacing.medium
        ) {
            StatCard(
                title: "APPLICATIONS",
                value: String(applications.count),
                subtext: "\(applicationsThisWeek.count) this week",
                icon: "doc.text",
                color: ColorTokens.primaryGreen
            )

            StatCard(
                title: "INTERVIEWS",
                value: String(interviewCount),
                subtext: "\(todayInterviewCount) today",
                icon: "person.2.wave.2",
                color: ColorTokens.highlightGreen
            )

            StatCard(
                title: "FOLLOW-UPS",
                value: String(activeFollowUpCount),
                subtext: "\(todayFollowUpCount) today",
                icon: "arrow.uturn.backward",
                color: ColorTokens.warning
            )

            StatCard(
                title: "OFFERS",
                value: String(offerCount),
                subtext: "Ready to negotiate",
                icon: "hand.thumbsup",
                color: ColorTokens.dimGreen
            )
        }
        .padding(.horizontal, Spacing.large)
    }

    private var todayInterviewCount: Int {
        todayEvents.filter { event in
            event.eventType == .interview
        }.count
    }

    private var todayFollowUpCount: Int {
        todayEvents.filter { event in
            event.eventType == .followUp
        }.count
    }

    private var todayScheduleSection: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            HStack {
                Text("TODAY'S SCHEDULE")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.primaryGreen)

                Spacer()

                if !todayEvents.isEmpty {
                    Text("\(todayEvents.count) EVENTS")
                        .font(
                            .system(
                                size: 10,
                                weight: .medium,
                                design: .monospaced
                            )
                        )
                        .foregroundStyle(ColorTokens.secondaryText)
                }
            }

            if todayEvents.isEmpty {
                Text("NO EVENTS TODAY")
                    .font(
                        .system(
                            size: 11,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .center
                    )
                    .padding(Spacing.medium)
            } else {
                ScrollView(
                    .horizontal,
                    showsIndicators: false
                ) {
                    HStack(spacing: Spacing.medium) {
                        ForEach(todayEvents) { event in
                            EventCard(event: event)
                                .frame(width: 150)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
        }
        .padding(.horizontal, Spacing.large)
    }

    private var quickAddSection: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            Text("QUICK ADD")
                .font(
                    .system(
                        size: 16,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.primaryGreen)

            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                HStack(spacing: Spacing.medium) {
                    ForEach(
                        ApplicationStage.allCases.prefix(4)
                    ) { stage in
                        Button {
                            presetStage = stage
                            showAddApplication = true
                        } label: {
                            VStack(spacing: Spacing.xSmall) {
                                Image(systemName: stage.icon)
                                    .font(.system(size: 20))
                                    .foregroundStyle(stage.color)

                                Text(stage.displayName)
                                    .font(
                                        .system(
                                            size: 9,
                                            weight: .medium,
                                            design: .monospaced
                                        )
                                    )
                                    .foregroundStyle(
                                        ColorTokens.highlightGreen
                                    )
                                    .lineLimit(1)
                            }
                            .frame(width: 80)
                            .padding(Spacing.small)
                            .background(ColorTokens.surface)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        ColorTokens.borderGreen,
                                        lineWidth: 1
                                    )
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, Spacing.large)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtext: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundStyle(color)

                Text(title)
                    .font(
                        .system(
                            size: 10,
                            weight: .medium,
                            design: .monospaced
                        )
                    )
                    .foregroundStyle(ColorTokens.secondaryText)
                    .lineLimit(1)
            }

            Text(value)
                .font(
                    .system(
                        size: 26,
                        weight: .bold,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.highlightGreen)

            Text(subtext)
                .font(
                    .system(
                        size: 10,
                        weight: .medium,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.secondaryText)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(Spacing.medium)
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(
                    ColorTokens.borderGreen,
                    lineWidth: 1
                )
        }
        .shadow(
            color: ColorTokens.primaryGreen.opacity(0.1),
            radius: 2,
            x: 0,
            y: 0
        )
    }
}

struct EventCard: View {
    let event: StoredCalendarEvent

    private var eventColor: Color {
        switch event.eventType {
        case .interview:
            return ColorTokens.highlightGreen
        case .recruiterCall:
            return ColorTokens.primaryGreen
        case .networking:
            return ColorTokens.secondaryText
        case .followUp:
            return ColorTokens.warning
        case .other:
            return ColorTokens.dimGreen
        }
    }

    private var eventIcon: String {
        switch event.eventType {
        case .interview:
            return "person.2.wave.2"
        case .recruiterCall:
            return "phone"
        case .networking:
            return "person.3"
        case .followUp:
            return "arrow.uturn.backward"
        case .other:
            return "calendar"
        }
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: Spacing.xSmall
        ) {
            Image(systemName: eventIcon)
                .font(.system(size: 18))
                .foregroundStyle(eventColor)

            Text(event.title)
                .font(
                    .system(
                        size: 11,
                        weight: .medium,
                        design: .monospaced
                    )
                )
                .foregroundStyle(ColorTokens.highlightGreen)
                .lineLimit(2)

            Text(
                event.startDate,
                style: .time
            )
            .font(
                .system(
                    size: 12,
                    weight: .bold,
                    design: .monospaced
                )
            )
            .foregroundStyle(ColorTokens.primaryGreen)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(Spacing.small)
        .background(ColorTokens.surface)
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(
                    eventColor.opacity(0.3),
                    lineWidth: 1
                )
        }
    }
}
