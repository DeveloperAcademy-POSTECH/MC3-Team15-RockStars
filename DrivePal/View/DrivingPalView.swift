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
    
    private enum MotionStatus {
        case none, normal, suddenAcceleration, suddenStop
    }
    
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 3.0
    private let activityManager = CMMotionActivityManager()
    private let accelerationQueue = OperationQueue()
    
    // MARK: - 가속도 역치 기준
    /// 급출발, 급가속 기준 11km/h -> 3m/s -> z: -1.1
    /// 급정지, 급감속 기준 7.5km/h -> 2m/s -> z: 0.75
    private let startThreshold = -1.1
    private let stopThreshold = 0.75
    
    @State private var motionStatus = MotionStatus.none
    @State private var zAcceleration = Double.zero
    @StateObject var locationHandler = LocationsHandler()
    // TODO: - 주행 모델이라고 해서 들어가보니까 Activity를 다루는 모델이라서 네이밍 변경 필요.
    @EnvironmentObject var model: LiveActivityModel
    
    private let palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat.zero
    @State private var movePalY = CGFloat.zero
    
    @State private var showResultAnalysisView = false
    
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
            if motionStatus == .none {
                Image("blueSky")
                    .resizable()
                    .scaledToFill()
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
                    .onTapGesture {
                        motionStatus = .normal
                    }
                Text("PRESS TO START")
                    .foregroundColor(.white)
                    .font(.headline)
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
            } else {
                // MARK: - Background scene
                SpriteView(scene: normalScene)
                    .onAppear(perform: actionsOnAppear)
                
                if [MotionStatus.suddenStop, .suddenAcceleration].contains(motionStatus) {
                    SpriteView(scene: abnormalScene)
                        .opacity(viewOpacity)
                        .onAppear(perform: showAbnormalBackground)
                }
                
                // driving pal
                Image(palImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.width - 100)
                    .padding(.vertical)
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 3 * 2 + movePalY)
                    .shake(movePalX)
                    .onAppear(perform: moveVerticallyPal)
                    .onChange(of: motionStatus, perform: moveHorizontallyPal)
                
                VStack {
                    VelocityView()
                        .environmentObject(locationHandler)
                    Button("주행 종료") {
                        motionStatus = .none
                        showResultAnalysisView.toggle()
                        model.simulator.end()
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showResultAnalysisView) {
            ResultAnalysisView(showResultAnalysisView: $showResultAnalysisView)
        }
        .ignoresSafeArea()
    }
    
    private func actionsOnAppear() {
        print("=== DEBUG: onappear")
        model.startLiveActivity()
        startAccelerometers()
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
            zAcceleration = data.acceleration.z
            
            if zAcceleration > stopThreshold || zAcceleration < startThreshold {
                model.simulator.count += 1
                model.simulator.progress += 0.25
                model.simulator.leadingImageName = "warning"
                model.simulator.trailingImageName = "warningCircle"
                model.simulator.isWarning = true
                motionStatus =  zAcceleration > stopThreshold ? .suddenStop : .suddenAcceleration
                model.simulator.accelerationData.append(ChartData(timestamp: .now, accelerationValue: zAcceleration))
                sleepThreadBriefly()
            } else {
                if model.simulator.count < 4 {
                    model.simulator.leadingImageName = "normal"
                }
                model.simulator.trailingImageName = ""
                model.simulator.isWarning = false
                motionStatus = .normal
            }
        }
    }
    
    private func showAbnormalBackground() {
        let blinkSecond = 4.0
        // 초기화
        viewOpacity = 0.0
        // 비정상 배경 뷰 보이게 함
        withAnimation(.easeIn(duration: 0.5)) {
            viewOpacity = 1.0
        }
        // 비정상 배경 뷰 숨김
        withAnimation(.easeOut(duration: 0.5).delay(blinkSecond)) {
            viewOpacity = 0.0
        }
    }
    
    private func moveVerticallyPal() {
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            movePalY = 20
        }
    }
    
    private func moveHorizontallyPal(_ currentStatus: MotionStatus) {
        guard currentStatus != .normal else {
            movePalX = 0
            return
        }
        withAnimation(Animation.linear(duration: 1.0).delay(0.5).repeatCount(2)) {
            movePalX = -10
        }
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}
