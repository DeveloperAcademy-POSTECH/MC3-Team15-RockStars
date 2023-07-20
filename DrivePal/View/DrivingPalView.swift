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
        case normal, suddenAcceleration, suddenStop, takingOff, landing
    }
    
    private let motionManager = CMMotionManager()
    private let operationQueue = OperationQueue()
    private let motionUpdateInterval = 1.0 / 2.0
    private let accelerationQueue = OperationQueue()
    
    // MARK: - 가속도 역치 기준
    /// 급출발, 급가속 기준 11km/h -> 3m/s -> z: -1.1
    /// 급정지, 급감속 기준 7.5km/h -> 2m/s -> z: 0.75
    private let startThreshold = -1.1
    private let stopThreshold = 0.75
    private let initHeight = UIScreen.height + 60
    
    @State private var motionStatus = MotionStatus.takingOff
    @State private var zAcceleration = Double.zero
    @StateObject var locationHandler = LocationsHandler()
    // TODO: - 주행 모델이라고 해서 들어가보니까 Activity를 다루는 모델이라서 네이밍 변경 필요.
    @EnvironmentObject var model: LiveActivityModel
    
    private let palImage = "planeWithShadow"
    @State private var viewOpacity = 0.0
    @State private var movePalX = CGFloat.zero
    @State private var movePalY = CGFloat.zero
    @State private var planeHeight = UIScreen.height + 60
    @State private var currentAcitivity = ""
    @State private var planeDegree = Double.zero
    @EnvironmentObject var automotiveDetector: CMMotionActivityManager
    private var timeStamp: Int {
        model.simulator.timestamp
    }
    @State private var timeStampWhenLanding = 999999
    
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
            SpriteView(scene: takeOffScene)
                .opacity(motionStatus == .takingOff ? 1 : 0)
            
            SpriteView(scene: normalScene)
                .opacity(motionStatus == .normal ? 1 : 0)
            
            SpriteView(scene: abnormalScene)
                .opacity([MotionStatus.suddenAcceleration, .suddenStop].contains(motionStatus) ? 1 : 0)
            
            SpriteView(scene: landingScene)
                .opacity(motionStatus == .landing ? 1 : 0)
            
            // driving pal
            VStack {
                Spacer()
                Image(palImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.width - 100)
                    .padding(.vertical)
                    .position(x: UIScreen.width / 2, y: planeHeight)
                    .shake(movePalX)
                    .onAppear(perform: moveVerticallyPal)
                    .rotationEffect(.init(degrees: planeDegree), anchor: .trailing)
                    .onChange(of: motionStatus, perform: moveHorizontallyPal)
                
                // TODO: - 추후 삭제 혹은 변경 예정
                HStack(spacing: 15) {
                    Button("takingOff") {
                        withAnimation {
                            motionStatus = .takingOff
                        }
                    }
                    Button("normal") {
                        withAnimation {
                            motionStatus = .normal
                        }
                    }
                    Button("landing") {
                        withAnimation {
                            motionStatus = .landing
                        }
                    }
                }
                .padding(.bottom, 100)
            }
            
            VelocityView()
                .environmentObject(locationHandler)
        }
        .onChange(of: motionStatus) { newStatus in // TODO: - 모션 상태 변화에 따른 행동 변화, 추후 Refactering 필요
            switch newStatus {
            case .normal:
                startAccelerometers()
            case .suddenAcceleration, .suddenStop:
                print("이상 기후 감지")
            case .takingOff:
                print("taking off")
            case .landing:
                print("landing")
                timeStampWhenLanding = timeStamp
            }
        }
        .onChange(of: timeStamp) { newValue in
            if newValue == 5 {
                print("앱시작해서 5초가 지났습니다.")
            }
            
            if newValue == timeStampWhenLanding + 5 {
                print("5초경과 landing 눌렀을 떄 !!!====")
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
        // TODO: - accelerameter data를 block에서 처리하면 오버헤드 발생
        // https://developer.apple.com/documentation/coremotion/cmmotionmanager/1616171-startaccelerometerupdates
        motionManager.startAccelerometerUpdates(to: accelerationQueue) { data, _ in
            guard let data else { return }
            zAcceleration = data.acceleration.z
            
            if [.landing, .takingOff].contains(motionStatus) {
                motionManager.stopAccelerometerUpdates()
                model.simulator.end()
                return
            }
            
            if zAcceleration > stopThreshold {
                model.simulator.count += 1
                model.simulator.progress += 0.25
                model.simulator.leadingImageName = "warning"
                model.simulator.trailingImageName = "warningCircle"
                model.simulator.isWarning = true
                withAnimation {
                    motionStatus = .suddenStop
                }
                
                sleepThreadBriefly()
            } else if zAcceleration < startThreshold {
                model.simulator.count += 1
                model.simulator.progress += 0.25
                model.simulator.leadingImageName = "warning"
                model.simulator.trailingImageName = "warningCircle"
                model.simulator.isWarning = true
                withAnimation {
                    motionStatus = .suddenAcceleration
                }
                sleepThreadBriefly()
            } else {
                if model.simulator.count < 4 {
                    model.simulator.leadingImageName = "normal"
                }
                model.simulator.trailingImageName = ""
                model.simulator.isWarning = false
                withAnimation {
                    motionStatus = .normal
                }
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
