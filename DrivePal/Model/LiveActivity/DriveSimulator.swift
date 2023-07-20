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
    var expandedImageName = ""
    var isWarning = false
    var motionStatus = ""
    weak var delegate: DriveSimulatorDelegate?

    // Init test data
    init() {
    }

    // Start a game by setting a time interval which fires of runGameSimulator every 2sec
    func start() {
        if simulatorStarted { return }
        simulatorStarted = true
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(runDriveSimulator), userInfo: nil, repeats: true)
    }

    // Reports to the delegate (GameModel in our case)
    func end() {
        delegate?.updateLiveActivity(driveState: endDrive())
        delegate?.stopLiveActivity()
    }

    // End the game by setting the winning team and resetting the vars
    func endDrive() -> DriveState {
        reset()
        return DriveState(count: 0, progress: 0.0, leadingImageName: "warning0", trailingImageName: "warningCircle1", expandedImageName: "normal1", timestamp: 0, isWarning: false, motionStatus: "normal")
    }

    // Reset the game to a fresh start
    private func reset() {
        timer?.invalidate()
        count = 0
        timestamp = 0
        simulatorStarted = false
    }

    @objc private func runDriveSimulator() {
        timestamp += 1
        // Tell the delegate to update its state
        
        delegate?.updateLiveActivity(driveState: DriveState(count: count, progress: progress, leadingImageName: "\(leadingImageName)\(timestamp % 6 + 1)", trailingImageName: "\(trailingImageName)\(timestamp % 4 + 1)", expandedImageName: "\(expandedImageName)\(timestamp % 6 + 1)", timestamp: timestamp, isWarning: isWarning, motionStatus: motionStatus))
    }
}
