//
//  DrivePalApp.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI

@main
struct DrivePalApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            DrivingPalView(model: DriveModel())
        }
    }
}
