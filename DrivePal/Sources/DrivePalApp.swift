//
//  DrivePalApp.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI
import BackgroundTasks
import CoreMotion

@main
struct DrivePalApp: App {
    @Environment(\.scenePhase) private var phase
    @StateObject private var model = LiveActivityModel.shared
    @StateObject private var locationHandler = LocationsHandler.shared
    private let backgroundTaskIdentifier = Bundle.main.backgroundTaskIdentifier
    private let activityManager = CMMotionActivityManager()
    
    var body: some Scene {
        WindowGroup {
            DrivingPalView()
                .environmentObject(model)
                .environmentObject(locationHandler)
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
                    UIApplication.shared.isIdleTimerDisabled = true
                    locationHandler.requestAuthorization()
                }
        }
        .onChange(of: phase) { currentPhase in
            switch currentPhase {
            case .background, .inactive:
                scheduleAppRefresh()
            default:
                break
            }
        }
        .backgroundTask(.appRefresh(backgroundTaskIdentifier)) {
            guard await !model.getLiveActivityStatus() else { return }
            activityManager.startActivityUpdates(to: .main) { activity in
                if let activity = activity {
                    if activity.automotive || activity.cycling {
                        let content = UNMutableNotificationContent()
                        content.title = I18N.appName
                        content.body = I18N.notificationMessage
                        content.sound = .default
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                        let request = UNNotificationRequest(identifier: "launchPromotion", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                    }
                }

            }
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        request.earliestBeginDate = .now.addingTimeInterval(5 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("=== DEBUG: scheduler submit")
        } catch {
            print("=== DEBUG: scheduler rejected")
        }
    }
}
