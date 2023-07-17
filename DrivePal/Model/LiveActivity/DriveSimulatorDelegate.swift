//
//  DriveSimulatorDelegate.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/17.
//

import Foundation
protocol DriveSimulatorDelegate: AnyObject {
    func updateLiveActivity(driveState: DriveState)
}
