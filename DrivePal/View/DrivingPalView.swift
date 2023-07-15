//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import CoreMotion
import SpriteKit

enum MotionStatus {
    case normal, suddenAcceleration, suddenStop
}

struct DrivingPalView: View {
    @StateObject var model: DriveModel
    
    let planeImage = "planeWithShadow"
    private let motionManager = CMMotionManager()
    private let activityManager = CMMotionActivityManager()
    private let accelerationQueue = OperationQueue()
    private let activityQueue = OperationQueue()
    @Environment(\.scenePhase) private var scenePhase
    @State private var motionStatus = MotionStatus.normal
    var motionUpdateInterval = 1.0 / 3.0
    @State private var valueZ = Double.zero
    
    // MARK: - 가속도 역치 기준
    /// 급출발, 급가속 기준 11km/h -> 3m/s -> z: -1.1
    /// 급정지, 급감속 기준 7.5km/h -> 2m/s -> z: 0.75
    private let startThreshold = -1.1
    private let stopThreshold = 0.75
    
    var palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat(0)
    @State private var movePalY = CGFloat(0)
    
    @State private var currentAcitivity = ""
    
    // background scenes
    private var normalScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .blueSky
        return scene
    }
    
    private var abnormalScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .redSky
        return scene
    }
    
    var body: some View {
        ZStack {
            // background scene
            SpriteView(scene: normalScene)
            
            if [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus) {
                SpriteView(scene: abnormalScene)
                    .opacity(viewOpacity)
                    .onAppear {
                        viewOpacity = 0.0
                        withAnimation(.easeIn(duration: 0.5)) {
                            viewOpacity = 1.0
                        }
                        withAnimation(.easeOut(duration: 0.5).delay(4.0)) {
                            viewOpacity = 0.0
                        }
                    }
            }
            
            // driving pal
            VStack {
                Spacer()
                Image(palImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width - 100)
                    .padding(.vertical)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3 * 2 + movePalY)
                    .modifier(Shake(animatableData: CGFloat(movePalX)))
                    .onAppear {
                        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
                            movePalY = 20
                        }
                    }
                    .onChange(of: motionStatus, perform: { currentStatus in
                        if currentStatus != .normal {
                            withAnimation(Animation.linear(duration: 1.0).delay(0.5).repeatCount(2)) {
                                movePalX = currentStatus == .normal ? 0 : -10
                            }
                        } else {
                            movePalX = 0
                        }
                    })
            }
            
            VStack {
                Spacer()
                ScrollView {
                    Text(currentAcitivity)
                        .fontDesign(.monospaced)
                }
                .frame(height: 200)
                .padding()
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
            startAccelerometers()
            startActivityUpdates()
        }
        .onChange(of: scenePhase) { currentPhase in
            if currentPhase == .inactive || currentPhase == .background {
                stopUpdates()
            }
        }
        .ignoresSafeArea()
    }
    
    private func sleepThreadBriefly() {
        motionManager.stopAccelerometerUpdates()
        Thread.sleep(forTimeInterval: 5)
        startAccelerometers()
    }
    
    private func startAccelerometers() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = motionUpdateInterval
        motionManager.startAccelerometerUpdates(to: accelerationQueue) { data, _ in
            guard let data else { return }
            valueZ = data.acceleration.z
            
            if valueZ > stopThreshold {
                motionStatus = .suddenStop
                sleepThreadBriefly()
            } else if valueZ < startThreshold {
                motionStatus = .suddenAcceleration
                sleepThreadBriefly()
            } else {
                motionStatus = .normal
            }
        }
    }
    
    private func startActivityUpdates() {
        activityManager.startActivityUpdates(to: activityQueue) { activity in
            if let activity = activity {
                if activity.walking {
                    currentAcitivity.append("walking ")
                }
                if activity.running {
                    currentAcitivity.append("running ")
                }
                if activity.cycling {
                    currentAcitivity.append("cycling ")
                }
                if activity.automotive {
                    currentAcitivity.append("automotive ")
                }
                if activity.stationary {
                    currentAcitivity.append("stationary ")
                }
            }
            currentAcitivity.append("\n")
        }
    }
    
    private func stopUpdates() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        
        activityManager.stopActivityUpdates()
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView(model: DriveModel())
    }
}
