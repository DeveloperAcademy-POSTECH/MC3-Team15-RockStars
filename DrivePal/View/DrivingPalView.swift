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

enum MotionStatus {
    case none, normal, suddenAcceleration, suddenStop, takingOff, landing
}

struct DrivingPalView: View {
    
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 2.0
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
    
    @State private var viewOpacity = 0.0
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
            // MARK: - BackgroundView
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
            
            // MARK: - PlaneView
            if [MotionStatus.normal,
                .takingOff,
                .landing,
                .suddenAcceleration,
                .suddenStop]
                .contains(motionStatus) {
                
                VStack {
                    PlaneView(motionStatus: $motionStatus)
                    
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
        .onChange(of: motionStatus, perform: actOn)
        .fullScreenCover(isPresented: $showResultAnalysisView) {
            ResultAnalysisView(showResultAnalysisView: $showResultAnalysisView)
        }
    }
}

struct DrivingPalView_Previews: PreviewProvider {
    static var previews: some View {
        DrivingPalView()
    }
}

// MARK: - CoreMotion 로직
private extension DrivingPalView {
    func sleepThreadBriefly() {
        stopAccelerometerUpdate()
        Thread.sleep(forTimeInterval: 5)
        startAccelerometerUpdate()
    }
    
    func stopAccelerometerUpdate() {
        motionManager.stopAccelerometerUpdates()
    }
    
    // TODO: - 메서드 길이 20줄 넘어감
    func startAccelerometerUpdate() {
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
}

// MARK: - Live Activity 로직
private extension DrivingPalView {
    func startLiveActivityUpdate() {
        model.startLiveActivity()
    }
    
    func stopLiveActivityUpdate() {
        model.simulator.end()
    }
}

// MARK: - Etc.. 추후 네이밍
private extension DrivingPalView {
     // MARK: - Etc에 배치한 이유: TakeOff, Landing 일 때만 일함
    /// 애니메이션 + 정보(LiveActivity, Accelerometer)도 업데이트 하기 때문
    private func actOn(_ motion: MotionStatus) {
        guard [MotionStatus.landing, .takingOff].contains(motion) else { return }
        if motion == .takingOff {
            actionsWhenTakeoff()
        } else if motion == .landing {
            transitionToInitiation()
        }
    }
    
    /// - 라이브 액티비티
    /// - 애니메이션
    /// - Motion Status
    /// - 결과분석뷰
    /// 4개의 로직을 리셋
    // MARK: - Etc에 배치한 이유: 화면 전환의 초기화 설정을 담당
    private func transitionToInitiation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            motionStatus = .none
            stopLiveActivityUpdate()
            showResultAnalysisView.toggle()
        }
    }
    
    private func actionsWhenTakeoff() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation {
                motionStatus = .normal
            }
            startLiveActivityUpdate()
            startAccelerometerUpdate()
        }
    }
}
