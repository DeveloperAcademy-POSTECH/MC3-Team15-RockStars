//
//  DrivingPalView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/13.
//

import SwiftUI
import SpriteKit

struct DrivingPalView: View {
    @State private var showResultAnalysisView = false
    @State private var showOnboardingView = true
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
            if [MotionStatus.none,
                .normal,
                .takingOff,
                .landing,
                .suddenAcceleration,
                .suddenStop]
                .contains(motionHandler.motionStatus) {
                
                PlaneView(motionStatus: $motionHandler.motionStatus)
                
                VStack {
                    if [MotionStatus.normal, .suddenAcceleration, .suddenStop]
                        .contains(motionHandler.motionStatus) {
                        VelocityView()
                            .environmentObject(locationHandler)
                            .onAppear(perform: locationHandler.requestAuthorization)
                            .padding(.top, 120)
                    }
                    
                    Spacer()

                    if motionHandler.motionStatus == .normal {
                        HStack {
                            Spacer()
                            ExitButton(motionStatus: $motionHandler.motionStatus)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboardingView) {
            OnboardingView()
        }
        .ignoresSafeArea()
        .onChange(of: motionHandler.motionStatus, perform: actOn)
        .fullScreenCover(isPresented: $showResultAnalysisView) {
            ResultTabView(showResultAnalysisView: $showResultAnalysisView)
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

// TODO: - Etc.. 추후 네이밍
private extension DrivingPalView {
    // MARK: - MotionHandler.motionStatus 변화를 감지할 메서드
    private func actOn(_ motion: MotionStatus) {
        if motionHandler.motionStatus == .takingOff {
            actionsWhenTakeoff()
        } else if motionHandler.motionStatus == .landing {
            transitionToInitiation()
        } else if motionHandler.motionStatus == .normal {
            liveActivityModel.simulator.updateWhenNormal()
        } else if motionHandler.motionStatus == .suddenAcceleration {
            liveActivityModel.simulator.updateWhenAbnormal(motionHandler.zAcceleration, false)
        } else if motionHandler.motionStatus == .suddenStop {
            liveActivityModel.simulator.updateWhenAbnormal(motionHandler.zAcceleration, true)
        } 
    }
    
    // MARK: - Etc에 배치한 이유: 화면 전환의 초기화 설정을 담당
    private func transitionToInitiation() {
        stopLiveActivityUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            motionHandler.motionStatus = .none
            showResultAnalysisView.toggle()
        }
    }
    
    private func actionsWhenTakeoff() {
        startLiveActivityUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation {
                motionHandler.motionStatus = .normal
            }
            motionHandler.startAccelerometerUpdate()
        }
    }
}
