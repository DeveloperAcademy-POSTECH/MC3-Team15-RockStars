//
//  SuddenAccelerationView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct SuddenAccelerationView: View {
    @State var leadingImageName: String
    @State var progress: Double
    @State var count: Int
    @State var timestamp: Int
    
    var body: some View {
        VStack {
            HStack {
                Image("\(leadingImageName)")
                    .resizable()
                    .frame(width: 54, height: 53)
                    .padding(.trailing, 17)
                VStack(alignment: .leading) {
                    Text("급가속 주의 속도 🎢 낮춰~")
                        .font(.system(size: 20, weight: .semibold))
                    HStack {
                        Image("locationPinPink")
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text("포항시 효성로 13번길 2")
                            .font(.system(size: 10))
                    }
                }
                Spacer()
            }
            .padding(.leading, 24)
            LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: "#FF26A8")
                .frame(width: 256)
            HStack {
                VStack {
                    Text("경고")
                        .font(.system(size: 8))
                        .opacity(0.8)
                    Text("+ 1번")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "0EF1FF"))
                }
                .padding(.leading, 96)
                Spacer()
                VStack(alignment: .leading) {
                    Text("운전시간")
                        .font(.system(size: 8))
                        .opacity(0.8)
                    HStack {
                        Text("\(timestamp / 60) min")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.leading, 55)
            }
        }
    }
}
