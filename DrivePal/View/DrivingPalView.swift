//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import CoreMotion
import SpriteKit

extension CMMotionActivityManager: ObservableObject { }

struct DrivingPalView: View {
    
    private enum MotionStatus {
        case none, normal, suddenAcceleration, suddenStop, takingOff, landing
    }
    
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 2.0
    private let accelerationQueue = OperationQueue()
    
    // MARK: - 가속도 역치 기준
    /// 급출발, 급가속 기준 11km/h -> 3m/s -> z: -1.05
    /// 급정지, 급감속 기준 7.5km/h -> 2m/s -> z: 0.55
    private let startThreshold = -1.05
    private let stopThreshold = 0.55
    private let initHeight = UIScreen.height - 50
    
    @State private var motionStatus = MotionStatus.none
    @State private var zAcceleration = Double.zero
    @StateObject var locationHandler = LocationsHandler()
    // TODO: - 주행 모델이라고 해서 들어가보니까 Activity를 다루는 모델이라서 네이밍 변경 필요.
    @EnvironmentObject var model: LiveActivityModel
    
    private let palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat.zero
    @State private var movePalY = CGFloat.zero
    @State private var planeHeight = UIScreen.height - 50
    @State private var planeDegree = Double.zero
    @State private var showResultAnalysisView = false
    @State private var showOnboardingView = true
    @EnvironmentObject var automotiveDetector: CMMotionActivityManager
    
    private var timeStamp: Int {
        model.simulator.timestamp
    }
    
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
    
    private var takeOffScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .startRunway
        return scene
    }
    
    private var landingScene: SKScene {
        let scene = BackgroundScene()
        scene.scaleMode = .fill
        scene.backgroundImageNamed = .finishAirport
        return scene
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background scene
            SpriteView(scene: normalScene)
            
            ZStack {
                Image("blueSky")
                    .resizable()
                    .scaledToFill()
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 2)
                    .onTapGesture {
                        motionStatus = .takingOff
                    }
                Image("startImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 75)
                    .position(x: UIScreen.width / 2, y: UIScreen.height / 3)
            }
            .opacity(motionStatus == .none ? 1 : 0)
            
            SpriteView(scene: takeOffScene)
                .opacity(motionStatus == .takingOff ? 1 : 0)
            
            SpriteView(scene: abnormalScene)
                .opacity([MotionStatus.suddenAcceleration, .suddenStop].contains(motionStatus) ? 1 : 0)
            
            SpriteView(scene: landingScene)
                .opacity(motionStatus == .landing ? 1 : 0)
            
            // driving pal
            if [MotionStatus.normal, .takingOff, .landing, .suddenAcceleration, .suddenStop].contains(motionStatus) {
                VStack {
                    Spacer()
                    Image(palImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.width - 100)
                        .padding(.vertical)
                        .position(x: UIScreen.width / 2,
                                  y: planeHeight + movePalY)
                        .rotationEffect(.degrees(planeDegree))
                        .shake(movePalX)
                        .onChange(of: motionStatus, perform: moveHorizontallyPal)
                        .onChange(of: motionStatus, perform: moveVerticallyPal)
                    
                    VelocityView()
                        .environmentObject(locationHandler)
                        .padding(.bottom, 50)
                    
                    if motionStatus == .normal {
                        Button {
                            withAnimation {
                                motionStatus = .landing
                            }
                        } label: {
                            Image("exit")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboardingView) {
            Onboarding()
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showResultAnalysisView) {
            ResultAnalysisView(showResultAnalysisView: $showResultAnalysisView)
        }
        .onChange(of: motionStatus) { newStatus in // TODO: - 모션 상태 변화에 따른 행동 변화, 추후 Refactering 필요
            switch newStatus {
            case .none:
                print("none")
            case .normal:
                print("normal")
            case .suddenAcceleration, .suddenStop:
                print("abnormal")
            case .takingOff:
                takeoff()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        motionStatus = .normal
                    }
                    actionsOnStartDriving()
                }
            case .landing:
                landing()
                reset()
            }
        }
    }
    
    private func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            motionStatus = .none
            showResultAnalysisView.toggle()
            model.simulator.end()
        }
    }
    
    private func actionsOnStartDriving() {
        model.startLiveActivity()
        startAccelerometers()
    }
    
    private func sleepThreadBriefly() {
        motionManager.stopAccelerometerUpdates()
        Thread.sleep(forTimeInterval: 5)
        startAccelerometers()
    }
    
    private func landing() {
        model.simulator.end()
        withAnimation(.linear(duration: 1.0)) {
            planeHeight = initHeight
            planeDegree = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                planeDegree = 8
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                planeDegree = 5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation {
                planeDegree = 0
            }
        }
    }
    
    private func takeoff() {
        withAnimation(.linear(duration: 1.5)) {
            planeHeight = UIScreen.height / 3 * 2
            planeDegree = -10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                planeDegree = -7
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                planeDegree = -3
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation {
                planeDegree = 0
            }
        }
    }
    
    private func startAccelerometers() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = motionUpdateInterval
        // TODO: - accelerameter data를 block에서 처리하면 오버헤드 발생
        // https://developer.apple.com/documentation/coremotion/cmmotionmanager/1616171-startaccelerometerupdates
        motionManager.startAccelerometerUpdates(to: accelerationQueue) { data, _ in
            guard let data else { return }
            zAcceleration = data.acceleration.z
            
            if motionStatus == .landing {
                motionManager.stopAccelerometerUpdates()
                return
            }
            
            // 급감속 또는 급가속 감지시
            if zAcceleration > stopThreshold || zAcceleration < startThreshold {
                model.simulator.count += 1
                model.simulator.progress += 0.25
                model.simulator.leadingImageName = "warning"
                model.simulator.trailingImageName = "warningCircle"
                model.simulator.expandedImageName = zAcceleration > stopThreshold ? "warnSignThunder" : "warnSignMeteor"
                model.simulator.motionStatus = zAcceleration > stopThreshold ? "suddenStop" : "suddenAcceleration"
                model.simulator.isWarning = true
                withAnimation {
                    motionStatus = zAcceleration > stopThreshold ? .suddenStop : .suddenAcceleration
                }
                model.simulator.accelerationData.append(ChartData(timestamp: .now, accelerationValue: zAcceleration))
                sleepThreadBriefly()
            } else { // 정상 주행시
                if model.simulator.count < 4 {
                    model.simulator.leadingImageName = "normal"
                    model.simulator.expandedImageName = "normal"
                } else {
                    model.simulator.leadingImageName = "warning"
                    model.simulator.expandedImageName = "warning"
                }
                model.simulator.trailingImageName = ""
                model.simulator.lockScreenImageName = "lockScreen"
                model.simulator.isWarning = false
                model.simulator.motionStatus = "normal"
                withAnimation {
                    motionStatus = .normal
                }
            }
        }
    }
    
    private func moveVerticallyPal(_ currentStatus: MotionStatus) {
        guard currentStatus == .normal else {
            movePalY = 0
            return
        }
        withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: true)) {
            movePalY = 20
        }
    }
    
    private func moveHorizontallyPal(_ currentStatus: MotionStatus) {
        guard [MotionStatus.suddenAcceleration, .suddenStop].contains(currentStatus) else {
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
