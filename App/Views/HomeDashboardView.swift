import SwiftUI
import SwiftData

struct HomeDashboardView: View {
    @Query private var applications: [JobApplication]
    @Query private var calendarEvents: [StoredCalendarEvent]
    
    @State private var selectedTab = 0
    
    private var todayEvents: [StoredCalendarEvent] {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let todayEnd = Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
        return calendarEvents.filter { $0.startDate >= todayStart && $0.startDate < todayEnd }
    }
    
    private var upcomingEvents: [StoredCalendarEvent] = {
        let todayStart = Calendar.current.startOfDay(for: Date())
        let thirtyDaysLater = Calendar.current.date(byAdding: .day, value: 30, to: todayStart)!
        return calendarEvents.filter { $0.startDate >= todayStart && $0.startDate <= thirtyDaysLater }
    }()
    
    private var applicationsThisWeek: [JobApplication] {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        return applications.filter { $0.appliedDate >= weekAgo }
    }
    
    var body: some View {
        VStack(spacing: Spacing.large) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: Spacing.xSmall) {
                    Text("OfferPath")
                        .font(Typography.title2)
                        .neonGreenText()
                    
                    Text("Job Application Tracker")
                        .font(Typography.caption)
                        .foregroundColor(ColorTokens.secondaryText)
                }
                
                Spacer()
                
                Button(action: { /* Navigate to Add Application */ }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(ColorTokens.primaryGreen)
                }
            }
            .padding(.horizontal, Spacing.large)
            .padding(.vertical, Spacing.medium)
            
            // Stats Cards
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: Spacing.medium) {
                StatCard(
                    title: "Applications",
                    value: "\(applications.count)",
                    subtext: "\(applicationsThisWeek.count) this week",
                    icon: "doc.text",
                    color: ColorTokens.primaryGreen
                )
                
                StatCard(
                    title: "Interviews",
                    value: "\(applications.filter { $0.stage == .interview }.count)",
                    subtext: "\(todayEvents.filter { $0.eventType == .interview }.count) today",
                    icon: "person.2.wave.2",
                    color: ColorTokens.highlightGreen
                )
                
                StatCard(
                    title: "Follow-ups",
                    value: "\(applications.filter { $0.followUpDate != nil && $0.followUpDate! > Date() }.count)",
                    subtext: "\(todayEvents.filter { $0.eventType == .followUp }.count) today",
                    icon: "arrow.uturn.backward",
                    color: ColorTokens.warning
                )
                
                StatCard(
                    title: "Offers",
                    value: "\(applications.filter { $0.stage == .offer }.count)",
                    subtext: "Ready to negotiate",
                    icon: "hand.thumbsup",
                    color: ColorTokens.dimGreen
                )
            }
            .padding(.horizontal, Spacing.large)
            
            // Today's Events
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                HStack {
                    Text("Today's Schedule")
                        .font(Typography.title3)
                        .neonGreenText()
                    
                    Spacer()
                    
                    if !todayEvents.isEmpty {
                        Text("\(todayEvents.count) events")
                            .font(Typography.caption)
                            .foregroundColor(ColorTokens.secondaryText)
                    }
                }
                
                if todayEvents.isEmpty {
                    Text("No events today")
                        .font(Typography.caption)
                        .foregroundColor(ColorTokens.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(Spacing.medium)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Spacing.medium) {
                            ForEach(todayEvents) { event in
                                EventCard(event: event)
                                    .frame(width: 120)
                            }
                        }
                        .padding(.horizontal, Spacing.large)
                    }
                    .padding(.vertical, Spacing.xSmall)
                }
            }
            .padding(.horizontal, Spacing.large)
            
            // Quick Add Section
            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                HStack {
                    Text("Quick Add")
                        .font(Typography.title3)
                        .neonGreenText()
                    
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.medium) {
                        ForEach(ApplicationStage.allCases.prefix(4), id: \.self) { stage in
                            Button(action: { /* Navigate to add with preset stage */ }) {
                                VStack {
                                    Image(systemName: stage.icon)
                                        .font(.system(size: 20))
                                        .foregroundColor(stage.color)
                                    
                                    Text(stage.displayName)
                                        .font(.caption2)
                                        .lineLimit(1)
                                }
                                .frame(width: 60)
                                .padding(Spacing.xSmall)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(ColorTokens.borderGreen, lineWidth: 1)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(ColorTokens.surface)
                                        )
                                )
                            }
                        }
                    }
                    .padding(.horizontal, Spacing.large)
                }
                .padding(.vertical, Spacing.xSmall)
            }
            .padding(.horizontal, Spacing.large)
            
            Spacer()
        }
        .background(ColorTokens.background.ignoresSafeArea())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtext: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                
                Text(title)
                    .font(Typography.caption)
                    .foregroundColor(ColorTokens.secondaryText)
            }
            
            Text(value)
                .font(Typography.title2)
                .neonGreenText()
                .font(Typography.digitalFont)
            
            Text(subtext)
                .font(Typography.caption)
                .foregroundColor(ColorTokens.secondaryText)
        }
        .padding(Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorTokens.borderGreen, lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ColorTokens.surface)
                )
                .shadow(color: ColorTokens.primaryGreen.opacity(0.1), radius: 2, x: 0, y: 0)
        )
    }
}

struct EventCard: View {
    let event: StoredCalendarEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xSmall) {
            Image(systemName: event.eventType.icon)
                .font(.system(size: 18))
                .foregroundColor(event.eventType.color)
            
            VStack(alignment: .leading, spacing: Spacing.xxxSmall) {
                Text(event.title)
                    .font(Typography.caption)
                    .lineLimit(1)
                
                Text(event.startDate, style: .time)
                    .font(Typography.digitalFont)
                    .font(.system(size: 12))
                    .foregroundColor(ColorTokens.primaryGreen)
            }
        }
        .padding(Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(event.eventType.color.opacity(0.3), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(ColorTokens.surface)
                )
        )
    }
}
