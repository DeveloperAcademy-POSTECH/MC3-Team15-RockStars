//
//  DrivingModel.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

final class LiveActivityModel: ObservableObject, DriveSimulatorDelegate {
    static let shared = LiveActivityModel()
    @Published var currentState = DriveState(count: 0,
                                             suddenAccelerationCount: 0,
                                             suddenStopCount: 0,
                                             progress: 0.0,
                                             leadingImageName: .palNormal,
                                             trailingImageName: "",
                                             expandedImageName: .palNormal,
                                             lockScreenImageName: .lockScreen,
                                             timestamp: 0,
                                             isWarning: false,
                                             motionStatus: .normal,
                                             shouldDisplayAlert: false,
                                             address: "")
    var liveActivity: Activity<DriveAttributes>?
    var driveAlreadyStarted = false
    let simulator = DriveSimulator()
    
    func getLiveActivityStatus() -> Bool {
        driveAlreadyStarted
    }
    
    init() {
        simulator.delegate = self
    }
    
    @objc func startLiveActivity() {
        if driveAlreadyStarted { return }
        let attributes = DriveAttributes()
        let currentDriveState = ActivityContent(state: DriveAttributes.ContentState(driveState: currentState), staleDate: nil)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, content: currentDriveState)
        } catch {
            print("=== DEBUG: \(error.localizedDescription)")
        }
        
        driveAlreadyStarted = true
        simulator.start()
    }
    
    func updateLiveActivity(driveState: DriveState) {
        self.currentState = driveState
        let updatedDriveStatus = DriveAttributes.ContentState(driveState: driveState)
        Task {
            let alertConfiguration = AlertConfiguration(
                title: "급감속/급가속주의",
                body: "경고: \(driveState.count)",
                sound: .default
            )
            await liveActivity?.update(using: updatedDriveStatus, alertConfiguration: driveState.shouldDisplayAlert ? alertConfiguration : nil)
            simulator.shouldDisplayAlert = false
        }
    }
    
    func stopLiveActivity() {
        Task {
            await liveActivity?.end(dismissalPolicy: .immediate)
        }
        driveAlreadyStarted = false
    }
}
