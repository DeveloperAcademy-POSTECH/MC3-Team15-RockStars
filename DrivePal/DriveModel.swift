//
//  DrivingModel.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

final class DriveModel: ObservableObject, DriveSimulatorDelegate {
    @Published var currentState = DriveState(count: 0, imageName: "warning1", timestamp: 0)
    var liveActivity: Activity<DrivePalWidgetExtensionAttributes>?
    var timer: Timer?
    var driveAlreadyStarted = false
    let simulator = DriveSimulator()
    
    init() {
        simulator.delegate = self
    }
    
    @objc func startLiveActivity() {
        if driveAlreadyStarted { return }
        
        let attributes = DrivePalWidgetExtensionAttributes()
        let currentDriveState = ActivityContent(state: DrivePalWidgetExtensionAttributes.ContentState(driveState: currentState), staleDate: nil)
        
        do {
            liveActivity = try Activity.request(attributes: attributes, content: currentDriveState)
        } catch {
            print(error.localizedDescription)
        }
        
        driveAlreadyStarted = true
        simulator.start()
    }
    
    func updateLiveActivity(driveState: DriveState) {
        print("**")
        self.currentState = driveState
        let updatedDriveStatus = DrivePalWidgetExtensionAttributes.ContentState(driveState: driveState)
        Task {
            print(updatedDriveStatus)
            await liveActivity?.update(using: updatedDriveStatus)
        }

        print("Updated Drive Live Activity")
    }
    
    func stopLiveActivity() {
        Task {
            await liveActivity?.end(dismissalPolicy: .immediate)
            print("Cancelled Drive Live Activity")
        }
        driveAlreadyStarted = false
    }
}
