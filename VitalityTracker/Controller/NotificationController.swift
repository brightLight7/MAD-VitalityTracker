import UserNotifications

class NotificationController: ObservableObject
{
    private var showGoToSettingsAlert = false
    var showContinueWithoutNotificationsAlert = false
     var permissionStatusText: String? = nil
    static let shared = NotificationController()
    
    init(){}
    
    func requestPermission()
    {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        
    }
    
    func scheduleDailyReminder(remaining x: Int)
    {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["dailyReminder"])
        
        guard x > 0 else {return}
        
        let noun = (x == 1) ? "task" : "tasks"
        
        let content = UNMutableNotificationContent()
        content.title = "VitalityTracker"
        content.body = "You have \(x) \(noun) to complete - keep going!"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = 19
        date.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder",
                                            content: content,
                                            trigger: trigger)
    }
    
    
    
    
}

