import UserNotifications

final class NotificationService {
    static let shared = NotificationService()

    func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            print("Notification auth error: \(error)")
            return false
        }
    }

    func scheduleReminder(for card: Card) {
        guard let dueDate = card.dueDate,
              let title = card.title,
              !card.isCompleted else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Due"
        content.body = title
        content.sound = .default

        let triggerDate = dueDate.addingTimeInterval(-3600)
        guard triggerDate > Date() else { return }

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: card.id?.uuidString ?? UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error { print("Notification error: \(error)") }
        }
    }

    func cancelReminder(for card: Card) {
        guard let id = card.id?.uuidString else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
