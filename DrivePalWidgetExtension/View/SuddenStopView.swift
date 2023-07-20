//
//  SuddenStopView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct SuddenStopView: View {
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
                    Text("급감속 주의 📉  위험!")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#DFFF1C"))
                    HStack {
                        Image("locationPinYellow")
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text("포항시 효성로 13번길 2")
                            .font(.system(size: 10))
                            .opacity(0.4)
                    }
                }
                Spacer()
            }
            .padding(.leading, 24)
            LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: "#DFFF1C")
                .frame(width: 256)
            HStack {
                VStack {
                    Text("경고")
                        .font(.system(size: 8))
                        .opacity(0.4)
                    Text("+ 1번")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "DFFF1C"))
                }
                .padding(.leading, 96)
                Spacer()
                VStack(alignment: .leading) {
                    Text("운전시간")
                        .font(.system(size: 8))
                        .opacity(0.4)
                    HStack {
                        Text("\(timestamp / 60) min")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.4)
                    }
                }
                .padding(.leading, 55)
            }
        }
    }
}
