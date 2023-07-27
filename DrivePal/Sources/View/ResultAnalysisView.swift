//
//  ResultAnalysisView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/19.
//

import SwiftUI

struct ResultAnalysisView: View {
    @State private var palPositionX = CGFloat.zero
    @State private var palPositionY = CGFloat.zero
    @Binding var showResultAnalysisView: Bool
    var body: some View {
        ZStack {
            Color.resultBackgroundColor
            
            VStack {
                Image(.palInResult)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .position(x: palPositionX, y: 200 + palPositionY)
                    .onAppear(perform: movePalHorizontally)
                
                ZStack {
                    Rectangle()
                        .frame(width: 244, height: 180)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                    
                    VStack {
                        Text("운전 시간  : \(LiveActivityModel.shared.simulator.timestamp / 60)분 \(LiveActivityModel.shared.simulator.timestamp % 60)초")
                            .resultTextModifier()
                        
                        Spacer()
                        
                        Text("부주의  : \(LiveActivityModel.shared.simulator.count)회")
                            .resultTextModifier()
                    }
                    .padding(.vertical, 80)
                    
                    VStack {
                        HStack {
                            Text("RESULT")
                                .font(.system(size: 32, weight: .bold))
                                .padding(.leading, 30)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .frame(width: 264, height: 220)
                
                ZStack {
                    ChartView(data: LiveActivityModel.shared.simulator.accelerationData)
                    
                    Button(I18N.buttonPopToRoot) {
//                        NavigationUtil.popToRootView()
                        // TODO: - 일단 이전뷰로 돌아가도록 함. 추후 수정 필요.
                        showResultAnalysisView = false
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func movePalHorizontally() {
        withAnimation(.linear(duration: 4.0)) {
            palPositionX = UIScreen.width / 2
        }
    }
}