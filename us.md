# Flowboard - iOS Development Guide

## Executive Summary

Flowboard is a native iOS/iPadOS/macOS project management app designed for independent entrepreneurs, freelancers, and small teams (1-10 people). It delivers the fastest path from zero to organized with an ultra-minimal kanban board experience.

**Product Vision**: Strip away the bloat of enterprise tools like Monday, Asana, and ClickUp. Give small teams exactly what they need: beautiful boards, fast task creation, and zero configuration.

**Key Differentiators**:
- Pure native Swift/SwiftUI - no Electron wrappers, no web views
- Zero-config startup - create tasks on first launch, no signup required
- Offline-first with silent iCloud sync via CloudKit
- Natural language task input ("Call client tomorrow !! #urgent")
- AI-powered task breakdown (Claude API)
- Fair pricing - no per-user billing, feature-tier pricing only

**Target Market**: US-based solopreneurs, freelancers, and micro-teams who are frustrated with tool bloat, steep learning curves, and per-user pricing from enterprise solutions.

## Competitive Analysis

| App | Strengths | Weaknesses | Our Advantage |
|-----|-----------|------------|---------------|
| Trello | Intuitive drag-and-drop, visual kanban, large user base | Limited free tier, iOS bugs (iOS 26), no offline editing, Power-Ups cost extra, $62/year for premium | Native performance, full offline support, no Power-Up dependency, 60% cheaper Pro tier |
| Linear | Blazing fast, beautiful design, keyboard-first, developer-focused | Requires account signup, per-user pricing ($8/user/mo), companion-only mobile app, not for non-tech teams | No signup required, flat pricing, full mobile experience, non-technical user friendly |
| Monday.com | Highly customizable, multiple views, strong automations | Expensive ($9+/user/mo), steep learning curve, feature overload for small teams, slow mobile app | Zero learning curve, flat $2.99/mo pricing, instant onboarding, native speed |
| Asana | Robust task dependencies, good integrations, scalable | Overwhelming for small teams, $10.99/user/mo, complex setup, poor offline support | Simple by default, offline-first, no per-user cost, 5-minute setup |
| ClickUp | All-in-one platform, 1000+ integrations, generous free tier | Interface complexity, overwhelming for basic needs, slow performance, feature bloat | Minimal feature set, instant performance, focused experience, no feature fatigue |

## Apple Design Guidelines Compliance

- **HIG Navigation**: TabView with 4 tabs (Boards, Calendar, Today, Settings) following standard iOS navigation patterns
- **HIG Modality**: Card detail uses sheet presentation; task creation uses inline expansion
- **HIG Gestures**: Drag-and-drop for card reordering follows standard UIKit drag protocols
- **HIG Dark Mode**: Full semantic color support using Apple system colors; custom colors defined in Asset Catalog with light/dark variants
- **HIG Typography**: SF Pro system font with Dynamic Type support for accessibility
- **HIG Haptics**: UIImpactFeedbackGenerator for drag completion, UINotificationFeedbackGenerator for task completion
- **HIG Privacy**: No data collection beyond local storage; iCloud sync uses user's own CloudKit container; no third-party analytics
- **App Store Review 3.1.2**: Subscription uses StoreKit 2 with auto-renewal; clear cancellation instructions in Terms of Use
- **App Store Review 5.1.1**: Privacy Policy clearly states minimal data collection; no tracking; no third-party data sharing

## Technical Architecture

- **Language**: Swift 5.9+
- **Framework**: SwiftUI (primary), UIKit (drag-and-drop enhancements if needed)
- **Architecture**: MVVM + Repository pattern
- **Data**: CoreData with NSPersistentCloudKitContainer for iCloud sync
- **Networking**: URLSession for Claude API and feedback backend
- **Payments**: StoreKit 2 for subscription management
- **Notifications**: UserNotifications for local reminders
- **Widgets**: WidgetKit for home screen "Today's Tasks" widget
- **AI**: Claude API (Anthropic) for task breakdown
- **Charts**: Swift Charts for progress visualization

## Module Structure

```
Flowboard/
├── App/
│   ├── FlowboardApp.swift
│   └── MainTabView.swift
├── Core/
│   ├── Persistence/
│   │   ├── PersistenceController.swift
│   │   └── Flowboard.xcdatamodeld
│   ├── Repositories/
│   │   ├── BoardRepository.swift
│   │   ├── ColumnRepository.swift
│   │   ├── CardRepository.swift
│   │   └── TagRepository.swift
│   ├── Services/
│   │   ├── SubscriptionManager.swift
│   │   ├── NotificationService.swift
│   │   ├── NaturalLanguageParser.swift
│   │   ├── AIService.swift
│   │   └── SyncMonitor.swift
│   └── Models/
│       ├── Board+Extensions.swift
│       ├── Column+Extensions.swift
│       ├── Card+Extensions.swift
│       └── Tag+Extensions.swift
├── Features/
│   ├── BoardList/
│   │   ├── BoardListView.swift
│   │   └── BoardListViewModel.swift
│   ├── Board/
│   │   ├── BoardView.swift
│   │   ├── BoardViewModel.swift
│   │   ├── ColumnView.swift
│   │   └── CardRowView.swift
│   ├── Card/
│   │   ├── CardDetailView.swift
│   │   └── CardDetailViewModel.swift
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   └── CalendarViewModel.swift
│   ├── Today/
│   │   ├── TodayView.swift
│   │   └── TodayViewModel.swift
│   ├── Settings/
│   │   ├── SettingsView.swift
│   │   └── ContactSupportView.swift
│   ├── Paywall/
│   │   ├── PaywallView.swift
│   │   └── PaywallViewModel.swift
│   └── Onboarding/
│       └── OnboardingView.swift
├── Components/
│   ├── CardDragPreview.swift
│   ├── PriorityBadge.swift
│   ├── TagChip.swift
│   ├── ProgressBar.swift
│   └── FABButton.swift
├── Extensions/
│   ├── Color+Flowboard.swift
│   ├── Date+Extensions.swift
│   └── View+Extensions.swift
└── Resources/
    ├── Assets.xcassets
    └── Flowboard.xcdatamodeld
```

## Implementation Flow

1. Set up CoreData model (Board, Column, Card, Tag entities with relationships)
2. Implement PersistenceController with NSPersistentCloudKitContainer
3. Build Repository layer (BoardRepository, CardRepository, etc.)
4. Create MainTabView with 4-tab navigation
5. Implement BoardList feature (list, create, delete boards)
6. Implement Board feature (kanban view with columns and cards)
7. Implement drag-and-drop for card reordering within and across columns
8. Implement CardDetail feature (edit title, description, due date, priority, tags)
9. Implement NaturalLanguageParser for quick task input
10. Implement NotificationService for due date reminders
11. Implement CalendarView for date-based task browsing
12. Implement TodayView for focused daily task view
13. Implement SubscriptionManager with StoreKit 2
14. Implement PaywallView with subscription tiers
15. Implement SettingsView with policy links and sync status
16. Implement ContactSupportView with feedback backend
17. Implement OnboardingView (3-page welcome)
18. Implement WidgetKit "Today's Tasks" widget
19. Add dark mode support with semantic colors
20. Test on iPhone and iPad simulators

## UI/UX Design Specifications

- **Color Scheme**:
  - Primary: #4A90D9 (light) / #5AA0E9 (dark)
  - Secondary: #7B68EE (light) / #9B88FF (dark)
  - Background: System backgrounds (automatic dark mode)
  - Card: System background with subtle shadow
  - Priority colors: Red (urgent), Orange (high), Yellow (medium), Gray (low)

- **Typography**:
  - Large Title: 34pt Bold (board names, section headers)
  - Title 2: 22pt Semibold (card titles in detail)
  - Headline: 17pt Semibold (card titles in list)
  - Body: 17pt Regular (descriptions, content)
  - Caption: 13pt Regular (dates, metadata)

- **Layout**:
  - Kanban column width: 280pt fixed
  - Column spacing: 16pt
  - Card spacing: 8pt
  - Card corner radius: 10pt
  - Card padding: 12pt
  - Column corner radius: 12pt
  - FAB button: 56x56pt, bottom-right 16pt margin
  - iPad: Content max width 720pt centered

- **Animations**:
  - Card drag: Spring scale 1.05x (0.2s)
  - Card drop: Spring bounce back (0.3s)
  - Task complete: Scale down + strikethrough (0.4s)
  - FAB expand: Scale + rotate (0.2s spring)
  - Page transition: Slide (0.35s easeInOut)

## Code Generation Rules

- Use @StateObject for ViewModel creation, @EnvironmentObject for shared services
- All CoreData operations go through Repository layer, never direct in View
- Use @FetchRequest for reactive CoreData queries in Views
- All CoreData attributes must be optional or have default values
- All CoreData relationships must have inverse relationships
- Use NSPersistentCloudKitContainer for iCloud sync
- Use semantic system colors for automatic dark mode
- Minimum touch target: 44x44pt
- Support Dynamic Type for accessibility
- Add accessibility labels for VoiceOver
- No comments in code unless explicitly requested
- Follow MVVM pattern strictly: View -> ViewModel -> Repository -> CoreData

## Build & Deployment Checklist

1. Verify Bundle ID: com.zzoutuo.Flowboard
2. Verify Deployment Target: iOS 17.0
3. Configure App Icon in Asset Catalog
4. Enable iCloud capability with CloudKit container
5. Enable Push Notifications capability
6. Configure StoreKit 2 subscription products in App Store Connect
7. Create StoreKit Configuration file for testing
8. Build and test on iPhone XS Max simulator
9. Build and test on iPad Pro 13-inch (M4) simulator
10. Verify no API keys or secrets in source code
11. Push to GitHub repository
12. Deploy policy pages to GitHub Pages
13. Submit to App Store Connect for review
