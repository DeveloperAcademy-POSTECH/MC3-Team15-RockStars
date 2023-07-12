//
//  DrivingModel.swift
//  DrivePal
//
//  Created by jaelyung kim on 2023/07/12.
//

import SwiftUI
import ActivityKit

final class DriveModel: ObservableObject {
    init() {
        startLiveActivity()
    }
    
    func startLiveActivity() {
        let attributes = DrivePalWidgetExtensionAttributes(name: "me")
        let currentDriveState = ActivityContent(state: DrivePalWidgetExtensionAttributes.ContentState(count: 0, imageName: "airplane.circle.fill"), staleDate: nil)
        
        do {
            let liveActivity = try Activity.request(attributes: attributes, content: currentDriveState)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateLiveActivity() {
        
        print("**")
        Task {
            let updatedDriveStatus = DrivePalWidgetExtensionAttributes.ContentState(count: 0, imageName: "airplane.circle")
            
            for activity in Activity<DrivePalWidgetExtensionAttributes>.activities{
                await activity.update(using: updatedDriveStatus)
            }

            print("Updated Drive Live Activity")
        }
    }
    
    func stopLiveActivity() {
        Task {
            for activity in Activity<DrivePalWidgetExtensionAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }

            print("Cancelled Drive Live Activity")

        }
    }

}
