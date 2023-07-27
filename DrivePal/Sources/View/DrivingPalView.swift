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
    @EnvironmentObject var liveActivityModel: LiveActivityModel

    var body: some View {
        ZStack {
            ConvertibleBackgroundView(motionStatus: $locationHandler.motionStatus)
            
            // MARK: - PlaneView
            if [MotionStatus.normal,
                .takingOff,
                .landing,
                .suddenAcceleration,
                .suddenStop]
                .contains(locationHandler.motionStatus) {
                
                VStack {
                    PlaneView(motionStatus: $locationHandler.motionStatus)
                    
                    if [MotionStatus.normal, .suddenAcceleration, .suddenStop]
                        .contains(locationHandler.motionStatus) {
                        VelocityView()
                            .environmentObject(locationHandler)
                            .onAppear(perform: locationHandler.requestAuthorization)
                            .padding(.bottom, 50)
                    }
                    
                    if locationHandler.motionStatus == .normal {
                        ExitButton(motionStatus: $locationHandler.motionStatus)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showOnboardingView) {
            OnboardingView()
        }
        .ignoresSafeArea()
        .onChange(of: locationHandler.motionStatus, perform: actOn)
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

// TODO: - Etc.. 추후 네이밍
private extension DrivingPalView {
    
    // MARK: - MotionHandler.motionStatus 변화를 감지할 메서드
    private func actOn(_ motion: MotionStatus) {
        if locationHandler.motionStatus == .takingOff {
            actionsWhenTakeoff()
        } else if locationHandler.motionStatus == .landing {
            transitionToInitiation()
        } else if locationHandler.motionStatus == .normal {
            liveActivityModel.simulator.updateWhenNormal()
        } else if locationHandler.motionStatus == .suddenAcceleration {
            liveActivityModel.simulator.updateWhenAbnormal(Double(locationHandler.speedModel.kilometerPerHour), false)
        } else if locationHandler.motionStatus == .suddenStop {
            liveActivityModel.simulator.updateWhenAbnormal(Double(locationHandler.speedModel.kilometerPerHour), true)
        } 
    }
    
    // MARK: - Etc에 배치한 이유: 화면 전환의 초기화 설정을 담당
    private func transitionToInitiation() {
        locationHandler.stopUpdateSpeed()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            locationHandler.motionStatus = .none
            stopLiveActivityUpdate()
            showResultAnalysisView.toggle()

        }
    }
    
    private func actionsWhenTakeoff() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            locationHandler.motionStatus = .normal
            startLiveActivityUpdate()
            locationHandler.updateSpeed()
        }
    }
}
