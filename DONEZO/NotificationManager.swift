import Foundation
import UserNotifications
import UIKit

// Make NotificationManager inherit from NSObject so it can be the UNUserNotificationCenterDelegate
final class NotificationManager: NSObject {
    static let shared = NotificationManager()

    private override init() {
        super.init()
    }

    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification authorization error: \(error.localizedDescription)")
            } else {
                print("✅ Notifications permission granted: \(granted)")
            }
        }

        // Set ourselves as the delegate to handle foreground/bkg events
        center.delegate = self
    }

    /// Schedule a one-time notification at a specific date/time.
    func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default  // or custom if you have one

        // Convert the target Date to year/month/day/hour/minute
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                          from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("⏰ Notification scheduled for \(date)")
            }
        }
    }

    /// Cancel (remove) a pending notification by its identifier
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        print("🚫 Notification with ID \(id) canceled")
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {

    /// Called when a notification arrives while the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                  @escaping (UNNotificationPresentationOptions) -> Void) {
        let identifier = notification.request.identifier
        let content = notification.request.content
        print("🔔 Foreground notification arrived: [\(identifier)] \(content.title) - \(content.body)")

        // Tell iOS to show banner, play sound, etc. even if app is in foreground.
        completionHandler([.banner, .sound, .badge])
    }

    /// Called when the user taps or responds to the notification (e.g., from the lock screen or banner).
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        let content = response.notification.request.content
        print("➡️ User tapped notification: [\(identifier)] \(content.title) - \(content.body)")
        
        // If you want to navigate user to a specific screen or handle custom actions, do so here.

        completionHandler()
    }
}
