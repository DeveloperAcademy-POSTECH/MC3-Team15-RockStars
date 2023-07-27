//
//  AfterFourWarningsView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct AfterFourWarningsView: View {
    @State var expandedImageName: String
    @State var progress: Double
    @State var count: Int
    @State var timestamp: Int
    
    var body: some View {
        ZStack {
            HStack(alignment: VerticalAlignment.top) {
                Image("\(expandedImageName)")
                    .resizable()
                    .frame(width: 54, height: 53)
                    .padding(.trailing, 5)
                VStack(alignment: .leading) {
                    Text(I18N.badDrivingNow)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.expandedWarning)
                    HStack {
                        Image(.locationPinRed)
                            .resizable()
                            .frame(width: 8, height: 10)
                        Text(I18N.currentLocationLA)
                            .font(.system(size: 10))
                    }
                    .padding(.bottom, 17)
                    HStack {
                        Text(I18N.warningTextLA)
                            .font(.system(size: 8))
                            .opacity(0.8)
                        Text(count.description)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.expandedWarning)
                        
                        Spacer()
                        
                        Text(I18N.drivingTimeTextLA)
                            .font(.system(size: 8))
                            .opacity(0.8)
                        Text("\(timestamp / 60) min")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .frame(width: UIScreen.width / 2.7)
                }
                Spacer()
            }
            .padding(.leading, 40)
            LinearProgressView(progress: progress < 1.0 ? progress : 1.0, linearColor: .expandedWarning)
                .frame(width: 256)
                .offset(y: 17)
        }
    }
}
