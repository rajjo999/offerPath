# OfferPath

A minimal job-application tracker for people searching for work.

## Features (MVP)

- ✅ Dashboard with application statistics
- ✅ Manual job-application entry
- ✅ Pipeline stages: Saved, Applied, Recruiter Screen, Interview, Offer, Rejected
- ✅ Application detail view
- ✅ Local persistence using SwiftData
- ✅ Pipeline Kanban board with drag-and-drop stage movement
- ✅ Add application form with validation
- ✅ Application detail editing
- ✅ Dark theme with neon green cyberpunk aesthetic
- ✅ Tab-based navigation: Home, Pipeline, Calendar, Practice, Settings

## Architecture

- **SwiftUI** for declarative UI
- **MVVM** pattern with separation of concerns
- **SwiftData** for local persistence
- **Dependency injection** for services
- **Protocol-oriented** design for easy backend integration (Supabase planned)

## Folder Structure

```
OfferPath/
├── App/                    # App entry point
├── Core/                   # Shared utilities, design system
│   ├── DesignSystem/       # Colors, typography, spacing
│   ├── Extensions/         # SwiftUI extensions
│   └── Protocols/          # Service protocols
├── Models/                 # Data models (SwiftData)
├── Services/               # Business logic services
│   └── Persistence/        # Data access layer
├── Features/               # Feature modules
│   ├── Onboarding/
│   ├── Home/
│   ├── Pipeline/
│   ├── Applications/
│   ├── Calendar/
│   ├── Practice/
│   └── Settings/
├── Resources/              # Preview data, assets
└── Tests/                  # Unit and UI tests
```

## Design System

- **Background**: `#050806` (near-black)
- **Surface**: `#0B120D` (dark surface)
- **Primary Green**: `#39FF68` (neon accent)
- **Highlight Green**: `#9CFFB0` (lighter accent)
- **Dim Green**: `#247A3A` (darker green)
- **Border Green**: `#16381F` (subtle border)
- **Secondary Text**: `#6E8975` (muted text)
- **Warning**: `#B8D65A` (accent warning)

## Next Planned Features (Post-MVP)

1. Calendar synchronization through EventKit
2. Follow-up reminders (local notifications)
3. AI interview question generation
4. AI follow-up email drafts
5. Resume and cover-letter checklist
6. Weekly dashboard analytics
7. Settings with notification preferences
8. Subscription placeholder for premium features

## Build Requirements

- iOS 17+
- Swift 6
- Xcode 15+
- SwiftData framework

## To Run

1. Open `OfferPath.xcodeproj` in Xcode
2. Select a device or simulator
3. Press `Cmd + R` to build and run

## Notes

- This implementation uses local persistence only (SwiftData)
- Networking and backend integration (Supabase) planned for future phases
- AI features will use a secure backend service - no API keys stored in app
- Follows Apple's Human Interface Guidelines and accessibility best practices
