//
//  ResultTabView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/30.
//

import SwiftUI

struct ResultTabView: View {
    @Binding var showResultAnalysisView: Bool
    @State private var selectedTabTag = 0
    var body: some View {
        NavigationStack {
            ScrollView {
                TabView(selection: $selectedTabTag) {
                    ChartView(data: LiveActivityModel.shared.simulator.accelerationData)
                        .tag(0)
                    ResultAnalysisView(showResultAnalysisView: $showResultAnalysisView)
                        .tag(1)
                }
                .frame(width: UIScreen.width, height: UIScreen.height)
                .tabViewStyle(.page(indexDisplayMode: .never))
                .navigationViewStyle(.stack)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showResultAnalysisView = false
                        } label: {
                            Image(systemName: .sfXmark)
                                .font(.system(size: 14, weight: .semibold))
                                .padding()
                                .foregroundColor(.white)
                        }
                    }
                }
                .overlay(
                    /// custom tabview style
                    ZStack {
                        Rectangle()
                            .frame(width: UIScreen.width, height: 4)
                            .foregroundColor(.white)
                            .opacity(0.2)
                        HStack(spacing: 0) {
                            Rectangle()
                                .frame(width: UIScreen.width/2, height: 4)
                                .foregroundColor(.white)
                                .opacity(selectedTabTag == 0 ? 0.8 : 0)
                            Rectangle()
                                .frame(width: UIScreen.width/2, height: 4)
                                .foregroundColor(.white)
                                .opacity(selectedTabTag == 1 ? 0.8 : 0)
                        }
                    }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                        .padding(.top, 45)
                    , alignment: .top
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
