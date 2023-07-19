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
    
    var data: [ChartData]
    
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
            .onAppear {
                print("=== DEBUG: chart data on ChartView \(LiveActivityModel.shared.simulator.accelerationData)")
            }
        }
    }
}
