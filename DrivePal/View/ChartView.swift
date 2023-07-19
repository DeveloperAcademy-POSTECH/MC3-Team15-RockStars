//
//  ChartView.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/19.
//

import SwiftUI
import Charts

struct ChartData: Identifiable {
    let id = UUID()
    var timestamp: Date
    var accelerationValue: Double
    
    init(timestamp: Date, accelerationValue: Double) {
        self.timestamp = timestamp
        self.accelerationValue = accelerationValue
    }
}

struct ChartView: View {
    
    @State private var data = [ChartData(timestamp: .now, accelerationValue: 0.7),
                               ChartData(timestamp: .now.addingTimeInterval(60), accelerationValue: -0.3),
                               ChartData(timestamp: .now.addingTimeInterval(60 * 2), accelerationValue: 1.0),
                               ChartData(timestamp: .now.addingTimeInterval(60 * 3), accelerationValue: 0.3),
                               ChartData(timestamp: .now.addingTimeInterval(60 * 4), accelerationValue: 0.5),
                               ChartData(timestamp: .now.addingTimeInterval(60 * 5), accelerationValue: 0.2)
                               ]
    
    var body: some View {
        VStack {
            Spacer()
            Chart(data) {
                LineMark(
                    x: .value("timestamp", $0.timestamp),
                    y: .value("value", $0.accelerationValue)
                )
                .lineStyle(StrokeStyle(lineWidth: 5, dash: [15, 20]))
                .interpolationMethod(.catmullRom)
                
                PointMark(
                    x: .value("timestamp", $0.timestamp),
                    y: .value("value", $0.accelerationValue)
                )
                .symbol {
                    ZStack {
                        Circle()
                            .foregroundColor(.black)
                            .frame(width: 20, height: 20)
                            .overlay {
                                Circle()
                                    .stroke(.white, lineWidth: 5)
                            }
                        
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.red)
                    }
                }
                
            }
            .frame(width: UIScreen.width - 40, height: UIScreen.height / 3)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .foregroundColor(.white)
        }
    }
}
