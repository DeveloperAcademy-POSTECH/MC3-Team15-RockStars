//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import SpriteKit

enum MotionStatus {
    case none, normal, suddenAcceleration, suddenStop, takingOff, landing
}

struct DrivingPalView: View {

    @State private var showResultAnalysisView = false
    @StateObject private var locationHandler = LocationsHandler()
    @StateObject private var motionHandler = MotionHandler()
    @EnvironmentObject var liveActivityModel: LiveActivityModel
    
    private var timeStamp: Int {
        liveActivityModel.simulator.timestamp
    }
    
    var body: some View {
        ZStack {
            ConvertibleBackgroundView(motionStatus: $motionHandler.motionStatus)
            
            // MARK: - PlaneView
            if [MotionStatus.normal,
                .takingOff,
                .landing,
                .suddenAcceleration,
                .suddenStop]
                .contains(motionHandler.motionStatus) {
                
                VStack {
                    PlaneView(motionStatus: $motionHandler.motionStatus)
                    
                    if [MotionStatus.normal, .suddenAcceleration, .suddenStop]
                        .contains(motionHandler.motionStatus) {
                        VelocityView()
                            .environmentObject(locationHandler)
                            .onAppear(perform: locationHandler.requestAuthorization)
                            .padding(.bottom, 50)
                    }
                    
                    if motionHandler.motionStatus == .normal {
                        Button {
                            withAnimation {
                                motionHandler.motionStatus = .landing
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
        .onChange(of: motionHandler.motionStatus, perform: actOn)
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

// MARK: - Live Activity 로직
private extension DrivingPalView {
    func startLiveActivityUpdate() {
        liveActivityModel.startLiveActivity()
    }
    
    func stopLiveActivityUpdate() {
        liveActivityModel.simulator.end()
    }
}

// MARK: - Etc.. 추후 네이밍
private extension DrivingPalView {
     // MARK: - Etc에 배치한 이유: TakeOff, Landing 일 때만 일함
    /// 애니메이션 + 정보(LiveActivity, Accelerometer)도 업데이트 하기 때문
    private func actOn(_ motion: MotionStatus) {
        if motionHandler.motionStatus == .takingOff {
            actionsWhenTakeoff()
        } else if motionHandler.motionStatus == .landing {
            transitionToInitiation()
        } else if motionHandler.motionStatus == .suddenAcceleration {
            liveActivityModel.updateWhenAbnormal(motionHandler.zAcceleration, false)
        } else if motionHandler.motionStatus == .suddenStop {
            liveActivityModel.updateWhenAbnormal(motionHandler.zAcceleration, true)
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
            motionHandler.motionStatus = .none
            stopLiveActivityUpdate()
            showResultAnalysisView.toggle()
        }
    }
    
    private func actionsWhenTakeoff() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            motionHandler.motionStatus = .normal
            startLiveActivityUpdate()
            motionHandler.startAccelerometerUpdate()
        }
    }
}
