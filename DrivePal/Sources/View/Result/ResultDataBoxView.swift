//
//  ResultDataBoxView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/30.
//

import SwiftUI

struct ResultDataBoxView: View {
    
    var dataBackgroundColor: Color
    var dataValue: Int
    var dataInText: String
    var isDrivingTimeData: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(dataValue.description)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .background {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(dataBackgroundColor)
                    }
                Text(isDrivingTimeData ? "min" : "")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.black)
                    .padding([.leading, .top], isDrivingTimeData ? 5 : 0)
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
    }
}
