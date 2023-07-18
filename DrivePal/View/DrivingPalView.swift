//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import CoreMotion
import SpriteKit

struct DrivingPalView: View {
    @StateObject var model: DriveModel
    @StateObject var locationHandler = LocationsHandler()
    let planeImage = "planeWithShadow"
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    
    @State private var motionStatus = MotionStatus.normal
    var motionUpdateInterval = 1.0 / 3.0
    @State private var valueZ = Double.zero
    private enum MotionStatus {
        case normal, suddenAcceleration, suddenStop
    }
    
    private let startThreshold = -1.1
    private let stopThreshold = 0.75
    
    var palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat(0)
    @State private var movePalY = CGFloat(0)
    
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
            
            // MARK: - Speed Console
            VStack {
                Spacer()
                switch locationHandler.authorizationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    Text("km/h: \(locationHandler.kilometerPerHour)")
                case .restricted, .denied:
                    Text("현재 지역에서 데이터를 읽어오는데 실패했습니다..")
                case .notDetermined:
                    Text("데이터를 읽어오고 있습니다..")
                    ProgressView()
                default:
                    ProgressView()
                }
            }
            .padding(.bottom, 30)
        }
        .onAppear(perform: startAccelerometers)
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
        motionManager.startAccelerometerUpdates(to: operationQueue) { data, _ in
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
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView(model: DriveModel())
    }
}
