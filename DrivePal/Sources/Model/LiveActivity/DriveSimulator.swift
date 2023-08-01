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
    var countSuddenAcceleration = 0
    var countSuddenStop = 0
    var progress = 0.0
    var timer: Timer?
    var timestamp = 0
    var simulatorStarted = false
    var leadingImageName = ""
    var trailingImageName = ""
    var expandedImageName = ""
    var lockScreenImageName = ""
    var isWarning = false
    var motionStatus = MotionStatus.normal
    weak var delegate: DriveSimulatorDelegate?
    
    var accelerationData = [ChartData]()

    // Init test data
    init() {
    }

    // Start a drive by setting a time interval which fires of runDriveSimulator every 1sec
    func start() {
        if simulatorStarted { return }
        reset()
        delegate?.updateLiveActivity(driveState: endDrive())
        simulatorStarted = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runDriveSimulator), userInfo: nil, repeats: true)
    }

    // Reports to the delegate (LiveActivityModel)
    func end() {
        delegate?.stopLiveActivity()
        simulatorStarted = false
        timer?.invalidate()
    }

    // End the drive by resetting the vars
    func endDrive() -> DriveState {
        return DriveState(count: 0, progress: 0.0, leadingImageName: .palNormal, trailingImageName: "", expandedImageName: .palNormal, lockScreenImageName: .lockScreen, timestamp: 0, isWarning: false, motionStatus: .normal)
    }

    // Reset the drive status to a fresh start
    private func reset() {
        count = 0
        timestamp = 0
        progress = 0.0
        leadingImageName = .palNormal
        trailingImageName = ""
        expandedImageName = .palNormal
        motionStatus = .normal
        lockScreenImageName = .lockScreen
        isWarning = false
        accelerationData.removeAll()
    }

    @objc private func runDriveSimulator() {
        timestamp += 1
        // Tell the delegate to update its state
        delegate?.updateLiveActivity(driveState: DriveState(count: count, progress: progress, leadingImageName: "\(leadingImageName)\(timestamp % 6 + 1)", trailingImageName: "\(trailingImageName)\(timestamp % 4 + 1)", expandedImageName: "\(expandedImageName)\(timestamp % 6 + 1)", lockScreenImageName: "\(lockScreenImageName)\(timestamp % 6 + 1)", timestamp: timestamp, isWarning: isWarning, motionStatus: motionStatus))
    }
}

extension DriveSimulator {
    func updateWhenAbnormal(_ zAcceleration: Double, _ isSuddenStop: Bool = true) {
        count += 1
        countSuddenStop += isSuddenStop ? 1 : 0
        countSuddenAcceleration += isSuddenStop ? 0: 1
        progress += 0.25
        leadingImageName = .palWarning
        trailingImageName = .circularWarning
        expandedImageName = isSuddenStop ? .warnSignThunder : .warnSignMeteor
        motionStatus = isSuddenStop ? MotionStatus.suddenStop : .suddenAcceleration
        isWarning = true
        accelerationData.append(ChartData(timestamp: .now, accelerationValue: zAcceleration))
    }
    
    func updateWhenNormal() {
        if count < 4 {
            leadingImageName = .palNormal
            expandedImageName = .palNormal
        } else {
            leadingImageName = .palWarning
            expandedImageName = .palWarning
        }
        trailingImageName = ""
        lockScreenImageName = .lockScreen
        isWarning = false
        motionStatus = .normal
    }
}
