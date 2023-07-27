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
    
    @Published var currentState = DriveState(count: 0, progress: 0.0, leadingImageName: "normal1", trailingImageName: "", expandedImageName: "normal1", lockScreenImageName: "lockScreen1", timestamp: 0, isWarning: false, motionStatus: "normal")
    var liveActivity: Activity<DriveAttributes>?
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

extension LiveActivityModel {
    func updateWhenAbnormal(_ zAcceleration: Double, _ isSuddenStop: Bool = true) {
        simulator.count += 1
        simulator.progress += 0.25
        simulator.leadingImageName = "warning"
        simulator.trailingImageName = "warningCircle"
        simulator.expandedImageName = isSuddenStop ? "warnSignThunder" : "warnSignMeteor"
        simulator.motionStatus = isSuddenStop ? "suddenStop" : "suddenAcceleration"
        simulator.isWarning = true
        simulator.accelerationData.append(ChartData(timestamp: .now, accelerationValue: zAcceleration))
    }
    
    func updateWhenNormal() {
        if simulator.count < 4 {
            simulator.leadingImageName = "normal"
            simulator.expandedImageName = "normal"
        } else {
            simulator.leadingImageName = "warning"
            simulator.expandedImageName = "warning"
        }
        simulator.trailingImageName = ""
        simulator.lockScreenImageName = "lockScreen"
        simulator.isWarning = false
        simulator.motionStatus = "normal"
    }
}
