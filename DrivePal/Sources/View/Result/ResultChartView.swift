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
    var timestamp: Int
    var value: Int
    
    init(timestamp: Int, value: Int) {
        self.timestamp = timestamp
        self.value = value
    }
}

struct ResultChartView: View {
    var data: [ChartData]
    private var pointThreshold: Int {
        if data.count < 4 {
            return 0
        }
        return data.sorted { $0.value > $1.value }[3].value
    }
    
    var body: some View {
        ZStack {
            Image(.backgroundResultChart)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if data.count > 0 {
                Chart(data, id: \.timestamp) { datum in
                    LineMark(
                        x: .value("timestamp", datum.timestamp),
                        y: .value("value", datum.value)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 9, lineCap: .round))
                    .interpolationMethod(.monotone)
                    
                    if datum.value >= pointThreshold {
                        PointMark(
                            x: .value("timestamp", datum.timestamp),
                            y: .value("value", datum.value)
                        )
                        .symbol {
                            VStack(spacing: 8) {
                                Text("\(datum.timestamp / 60) min")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("\(datum.value) km/h")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Image(.gaugeOnChart)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 55)
                            }
                            .padding(datum.value < 0 ? .top : .bottom, 120)
                        }
                    }
                }
                .frame(width: UIScreen.width - 60, height: UIScreen.height / 3)
                .scaledToFit()
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .foregroundColor(.white)
            }
            
            VStack(alignment: .center) {
                Text(I18N.wordRoadDrivingAnalysis)
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.wordsFromResultColor)
                    .opacity(0.85)
                    .padding(.top, 130)
                
                Spacer()
                
                Text(I18N.wordAnalysisCriteria)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .opacity(0.85)
                    .padding(.bottom, 50)
            }
        }
    }
}
