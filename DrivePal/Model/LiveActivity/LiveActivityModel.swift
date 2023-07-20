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
    
    @Published var currentState = DriveState(count: 0, progress: 0.0, leadingImageName: "warning1", trailingImageName: "warningCircle1", timestamp: 0, isWarning: false)
    var liveActivity: Activity<DriveAttributes>?
    var timer: Timer?
    var driveAlreadyStarted = false
    let simulator = DriveSimulator()
    
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
            await liveActivity?.update(using: updatedDriveStatus)
        }
    }
    
    func stopLiveActivity() {
        Task {
            await liveActivity?.end(dismissalPolicy: .immediate)
        }
        driveAlreadyStarted = false
    }
}
