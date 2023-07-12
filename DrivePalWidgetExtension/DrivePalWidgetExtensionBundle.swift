//
//  DrivePalWidgetExtensionBundle.swift
//  DrivePalWidgetExtension
//
//  Created by 제나 on 2023/07/11.
//

import WidgetKit
import SwiftUI

@main
struct DrivePalWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        DrivePalWidgetExtension()
        DrivePalWidgetExtensionLiveActivity()
    }
}
