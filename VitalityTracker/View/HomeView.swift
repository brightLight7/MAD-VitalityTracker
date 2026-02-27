import SwiftUI
import UserNotifications

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    @State private var showGoToSettingsAlert = false
    @State private var showContinueWithoutNotificationsAlert = false
    @State private var permissionStatusText: String? = nil
    @EnvironmentObject var controller: NotificationController
    
    var body: some View {
        NavigationStack
        {
            ScrollView
            {
                VStack(alignment: .leading, spacing: 16)
                {
                    Text("Welcome to VitalityTracker!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("""
                         Your all-in-one health and wellbeing companion.
                         This app is intended to help you stay on track with your daily goals and enforce healthy to support your vitality!
                         """)
                    .font(.body)
                    
                    Divider()
                    
                    Text("""
                        To start, it is recommended to press the button below to allow VitalityTracker to send you notifications when you
                        need to complete your daily habits. 
                        
                        Don't worry, you can manually turn off notifications whenever you like by navigation to:
                        Settings > Apps > VitalityTracker > Notifications.
                        """)
                    .font(.body)
                    
                    if let permissionStatusText
                    {
                        Text(permissionStatusText)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                    
                    VStack(spacing: 12)
                    {
                        Button
                        {
//                            controller.handleAllowNotificationsTapped()
                        }
                    label:
                        {
                            Text("Continue Without Notifications")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
//                .alert("Continue without enabling notifications?", isPresented: controller.showContinueWithoutNotificationsAlert)
//                {
//                    Button("No", role: .cancel) {}
//                    Button("Yes", role: .destructive)
//                    {
//                        hasSeenOnboarding = true
//                    }
//                }
//                message:
//                {
//                    Text("You can enable notifications later in Settings if you change your mind.")
//                }
                .alert("Notifications are disabled", isPresented: $showGoToSettingsAlert)
                {
                    Button("Cancel", role: .cancel) {}
                    Button("Open Settings")
                    {
//                        controller.openAppSettings()
                    }
                }
                message:
                {
                    Text("To enable notifications, open Settings and turn on notifications for VitalityTracker.")
                }
                
            }
        }
    }
}

