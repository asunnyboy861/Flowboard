# Capabilities Configuration

## Analysis
Based on operation guide analysis:
- "iCloud" / "同步" / "sync" detected → iCloud capability required
- "通知" / "提醒" / "notification" / "reminder" detected → Push Notifications capability required
- "订阅" / "会员" / "premium" / "subscription" detected → In-App Purchase capability required
- "Widget" / "小组件" detected → Widget Extension required
- "AI" / "Claude API" detected → Outgoing Network Connections required

## Auto-Configured Capabilities

| Capability | Status | Method |
|------------|--------|--------|
| Push Notifications | ✅ Configured | Xcode project settings |
| iCloud (CloudKit) | ✅ Configured | Xcode project settings |
| In-App Purchase | ✅ Configured | Xcode project settings |

## Manual Configuration Required

| Capability | Status | Steps |
|------------|--------|-------|
| iCloud Container | ⏳ Pending | 1. Open Xcode → Signing & Capabilities → Add iCloud → Check CloudKit → Create container "iCloud.com.zzoutuo.Flowboard" |
| CloudKit Schema | ⏳ Pending | 1. Deploy CoreData model to CloudKit via Xcode → Editor → CloudKit Schema |
| App Store Connect Subscriptions | ⏳ Pending | 1. Create subscription group "Flowboard Pro" 2. Add monthly ($2.99) and yearly ($24.99) products 3. Configure 7-day free trial |

## Widget Extension

| Item | Status | Steps |
|------|--------|-------|
| Widget Target | ⏳ Pending | 1. Add Widget Extension target in Xcode 2. Name: FlowboardWidget 3. Configure timeline provider |

## No Configuration Needed

- Camera / Photo Library: Not required
- Location Services: Not required
- HealthKit: Not required
- Sign in with Apple: Not required (no account system)
- Apple Watch: Not in MVP scope
- Siri / Shortcuts: Not in MVP scope

## Verification

- Build succeeded after configuration: ✅ Verified (iPhone + iPad)
- All entitlements correct: ✅ Verified
