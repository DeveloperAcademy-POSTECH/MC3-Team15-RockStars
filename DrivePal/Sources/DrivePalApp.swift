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
    private let backgroundTaskIdentifier = Bundle.main.backgroundTaskIdentifier
    private let activityManager = CMMotionActivityManager()
    
    var body: some Scene {
        WindowGroup {
            DrivingPalView()
                .environmentObject(model)
                .onAppear {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
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
            await activityManager.startActivityUpdates(to: .main) { activity in
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
        request.earliestBeginDate = .now.addingTimeInterval(10) // TODO: 인터벌에 대한 상의 필요
        do {
            try BGTaskScheduler.shared.submit(request)
            print("=== DEBUG: scheduler submit")
        } catch {
            print("=== DEBUG: scheduler rejected")
        }
    }
}
