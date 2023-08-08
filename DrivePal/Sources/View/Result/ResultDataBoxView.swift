//
//  ResultDataBoxView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/30.
//

import SwiftUI

struct ResultDataBoxView: View {
    
    var dataBackgroundColor: Color
    var dataValue: String
    var dataInText: String
    var isDrivingTimeData: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(dataValue)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(dataBackgroundColor)
                    }
                if isDrivingTimeData {
                    Text("min")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.black)
                        .padding([.leading, .top], 5)
                }
            }
            .padding(.vertical, 4)
            
            Text(dataInText)
                .foregroundColor(.dataTextColor)
                .font(.system(size: 16, weight: .bold))
        }
        .padding(.vertical, 10)
        .frame(width: 152)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.white)
                .opacity(0.9)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.dataBoxBorderColor, lineWidth: 2)
                }
        }
        .shadow(color: .black.opacity(0.25), radius: 4, y: 4)
    }
}
