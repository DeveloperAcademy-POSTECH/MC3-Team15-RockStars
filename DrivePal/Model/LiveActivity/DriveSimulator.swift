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
    var timer: Timer?
    var timestamp = 0
    var simulatorStarted = false
    var imageName = ""
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
    }

    // End the game by setting the winning team and resetting the vars
    func endDrive() -> DriveState {
        reset()
        return DriveState(count: 0, imageName: "warning0", timestamp: 0)
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
        delegate?.updateLiveActivity(driveState: DriveState(count: count, imageName: "\(imageName)\(timestamp % 6 + 1)", timestamp: timestamp))
    }
}
