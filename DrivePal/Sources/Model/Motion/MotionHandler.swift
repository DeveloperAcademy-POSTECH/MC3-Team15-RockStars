//
//  MotionHandler.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/26.
//

import SwiftUI
import CoreMotion

final class MotionHandler: ObservableObject {
    
    private let motionManager = CMMotionManager()
    private let accelerationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 2.0
    private let startThreshold = -1.05
    private let stopThreshold = 0.55
    
    private(set) var zAcceleration = Double.zero
    @Published var motionStatus: MotionStatus = .none
    
    func stopAccelerometerUpdate() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func startAccelerometerUpdate() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = motionUpdateInterval
        motionManager.startAccelerometerUpdates(to: accelerationQueue) { [unowned self] data, _ in
            guard let data else { return }
            zAcceleration = data.acceleration.z
            
            if motionStatus == .landing {
                motionManager.stopAccelerometerUpdates()
                return
            }
            
            // MARK: - 급감속
            if zAcceleration >= stopThreshold {
                Task.detached { @MainActor [unowned self] in
                    withAnimation {
                        self.motionStatus = .suddenStop
                    }
                }
                sleepThreadBriefly()
            // MARK: - 급출발
            } else if zAcceleration <= startThreshold {
                Task.detached { @MainActor [unowned self] in
                    withAnimation {
                        self.motionStatus = .suddenAcceleration
                    }
                }
                sleepThreadBriefly()
            } else {
                // MARK: - 정상 주행시
                Task.detached { @MainActor [unowned self] in
                    withAnimation {
                        self.motionStatus = .normal
                    }
                }
            }
        }
    }
    
    private func sleepThreadBriefly() {
        stopAccelerometerUpdate()
        Thread.sleep(forTimeInterval: 5)
        startAccelerometerUpdate()
    }
}
