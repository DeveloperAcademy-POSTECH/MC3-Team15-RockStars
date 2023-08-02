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
    @StateObject private var motionHandler = MotionHandler()
    @EnvironmentObject var liveActivityModel: LiveActivityModel
    @EnvironmentObject var locationHandler: LocationsHandler
    
    private var motionStatus: MotionStatus {
        get {
            #if DEBUG
            return motionHandler.motionStatus
            #elseif RELEASE
            return locationHandler.motionStatus
            #endif
        }
    }

    var body: some View {
        ZStack {
            #if DEBUG
            ConvertibleBackgroundView(motionStatus: $motionHandler.motionStatus)
            #elseif RELEASE
            ConvertibleBackgroundView(motionStatus: $locationHandler.motionStatus)
            #endif
            
            if motionStatus == .takingOff {
                DynamicInformView(motionStatus: motionStatus)
            }
            
            // MARK: - PlaneView
            PlaneView(motionStatus: motionStatus)
            
            VStack {
                if [MotionStatus.normal, .suddenAcceleration, .suddenStop]
                    .contains(motionStatus) {
                    VelocityView(motionStatus: motionStatus)
                        .padding(.top, 120)
                }
                
                Spacer()

                if motionStatus == .normal {
                    HStack {
                        Spacer()
                        #if DEBUG
                        ExitButton(motionStatus: $motionHandler.motionStatus)
                        #elseif RELEASE
                        ExitButton(motionStatus: $locationHandler.motionStatus)
                        #endif
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onChange(of: motionStatus, perform: actOn)
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
        if motionStatus == .takingOff {
            actionsWhenTakeoff()
        } else if motionStatus == .landing {
            transitionToInitiation()
        } else if motionStatus == .normal {
            liveActivityModel.simulator.updateWhenNormal()
        } else if motionStatus == .suddenAcceleration {
            liveActivityModel.simulator.updateWhenAbnormal(motionHandler.zAcceleration, false)
        } else if motionStatus == .suddenStop {
            liveActivityModel.simulator.updateWhenAbnormal(motionHandler.zAcceleration, true)
        }
    }
    
    // MARK: - Etc에 배치한 이유: 화면 전환의 초기화 설정을 담당
    private func transitionToInitiation() {
        locationHandler.stopUpdateSpeed()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation {
                #if DEBUG
                motionHandler.motionStatus = .none
                #elseif RELEASE
                locationHandler.motionStatus = .none
                #endif
            }
            stopLiveActivityUpdate()
            showResultAnalysisView.toggle()
        }
    }
    
    private func actionsWhenTakeoff() {
        startLiveActivityUpdate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            #if DEBUG
            withAnimation {
                motionHandler.motionStatus = .normal
            }
            motionHandler.startAccelerometerUpdate()
            #elseif RELEASE
            withAnimation {
                locationHandler.motionStatus = .normal
            }
            locationHandler.updateAuthorization()
            #endif
        }
    }
}
