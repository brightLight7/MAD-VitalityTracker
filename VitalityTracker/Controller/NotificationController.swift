import UserNotifications

class NotificationController: ObservableObject
{
    private var showGoToSettingsAlert = false
    var showContinueWithoutNotificationsAlert = false
     var permissionStatusText: String? = nil
    static let shared = NotificationController()
    
    init(){}
    
    func requestPermission(completion: @escaping (Bool) -> Void)
    {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
        DispatchQueue.main.async { completion(granted) }
        }
        
    }
    
    func scheduleDailyReminder(remaining x: Int, hour: Int = 19, minute: Int = 0)
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
        date.hour = hour
        date.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder",
                                            content: content,
                                            trigger: trigger)
        
        center.add(request)
        { error in
            if let error = error
            {
                print("Failed to schedule reminder: \(error)")
            }
        }
    }
    
    
    
    
}

