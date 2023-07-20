//
//  DriveSimulator.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/17.
//

import Foundation

final class DriveSimulator {
    // instance properties
    var count = 0
    var progress = 0.0
    var timer: Timer?
    var timestamp = 0
    var simulatorStarted = false
    var leadingImageName = ""
    var trailingImageName = ""
    var isWarning = false
    weak var delegate: DriveSimulatorDelegate?
    
    var accelerationData = [ChartData]()

    // Init test data
    init() {
    }

    // Start a drive by setting a time interval which fires of runDriveSimulator every 1sec
    func start() {
        if simulatorStarted { return }
        reset()
        simulatorStarted = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runDriveSimulator), userInfo: nil, repeats: true)
    }

    // Reports to the delegate (LiveActivityModel)
    func end() {
        delegate?.updateLiveActivity(driveState: endDrive())
        delegate?.stopLiveActivity()
    }

    // End the drive by resetting the vars
    func endDrive() -> DriveState {
        return DriveState(count: 0, progress: 0.0, leadingImageName: "warning0", trailingImageName: "warningCircle1", timestamp: 0, isWarning: false)
    }

    // Reset the drive status to a fresh start
    private func reset() {
        timer?.invalidate()
        count = 0
        timestamp = 0
        simulatorStarted = false
        accelerationData.removeAll()
    }

    @objc private func runDriveSimulator() {
        timestamp += 1
        // Tell the delegate to update its state
        
        delegate?.updateLiveActivity(driveState: DriveState(count: count, progress: progress, leadingImageName: "\(leadingImageName)\(timestamp % 6 + 1)", trailingImageName: "\(trailingImageName)\(timestamp % 4 + 1)", timestamp: timestamp, isWarning: isWarning))
    }
}
