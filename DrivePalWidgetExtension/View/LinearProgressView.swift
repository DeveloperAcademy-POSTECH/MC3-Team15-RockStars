//
//  LinearProgressView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct LinearProgressView: View {
    @State var progress = 0.0
    @State var linearColor: String

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: progress < 1 ? Color(hex: "4DBBDB") : Color(hex: linearColor)))
        }
    }
}
