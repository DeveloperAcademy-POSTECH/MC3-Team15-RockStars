//
//  CircularProgressView.swift
//  DrivePalWidgetExtension
//
//  Created by jaelyung kim on 2023/07/20.
//

import SwiftUI

struct CircularProgressView: View {
    @State var progress: Double = 0.0

    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(CircularProgressViewStyle(tint: progress < 1 ? .compactNormalCircular : .compactWarningCircular))
                
        }
    }
}
