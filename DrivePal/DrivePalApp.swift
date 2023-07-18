//
//  DrivePalApp.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/11.
//

import SwiftUI

@main
struct DrivePalApp: App {
    
    @StateObject private var model = DriveModel()
    
    var body: some Scene {
        WindowGroup {
            DrivingPalView()
                .environmentObject(model)
        }
    }
}
