//
//  SuddenStopView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct SuddenStopView: View {
    @State var expandedImageName: String
    @State var progress: Double
    @State var count: Int
    @State var timestamp: Int
    
    var body: some View {
        ZStack {
            HStack(alignment: VerticalAlignment.top) {
                ZStack {
                    Image("warnSignBackground")
                        .resizable()
                    Image("\(expandedImageName)")
                        .resizable()
                }
                .frame(width: 54, height: 53)
                .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text(I18N.suddenDeceleratedNow)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.expandedWarningDeceleration)
                    HStack {
                        Image("locationPinYellow")
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text(I18N.currentLocationLA)
                            .font(.system(size: 10))
                            .opacity(0.4)
                    }
                    .padding(.bottom, 17)
                    HStack {
                        Text(I18N.warningTextLA)
                            .font(.system(size: 8))
                            .opacity(0.4)
                        Text(I18N.countOneMoreWarning)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.expandedWarningDeceleration)
                        
                        Spacer()
                    
                        Text(I18N.drivingTimeTextLA)
                            .font(.system(size: 8))
                            .opacity(0.4)
                        Text("\(timestamp / 60) min")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(0.4)
                    }
                    .frame(width: UIScreen.width / 2.7)
                }
                Spacer()
            }
            .padding(.leading, 40)
            LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: .expandedWarningDeceleration)
                .frame(width: 256)
                .offset(y: 17)
        }
    }
}
