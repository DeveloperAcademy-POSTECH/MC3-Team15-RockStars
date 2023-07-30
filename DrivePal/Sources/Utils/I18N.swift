//
//  I18N.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/25.
//
//

/*
 Internationalization: I18N (일반적으로 쓰이는 용어)
 di: dynamic island
 LA: Live Activity
 
 Using localization
 https://developer.apple.com/documentation/swiftui/preparing-views-for-localization
 %lld: Integer
 %@: String
 Text("\(copyOperation.numFiles, specifier: "%lld")")
 */

import Foundation

struct I18N {

    /* App */
    static let appName = "app-name".localized()
    static let notificationMessage = "noti-msg".localized()

    /* Button */
    static let buttonPopToRoot = "pop-to-root".localized()

    /* Velocity View */
    static let debugUpdateSuccess = "update-success".localized()
    static let debugUpdateFailure = "update-failure".localized()
    static let debugUpdateMessage = "update-message".localized()
    
    /* Onboarding View */
    static let precautionTitle = "precaution-for-use-title".localized()
    static let precautionContent = ["precaution-for-use-content-0".localized(),
                                    "precaution-for-use-content-1".localized(),
                                    "precaution-for-use-content-2".localized() ]

    /* Live Activity */
    static let currentLocationLA = "current-location".localized()
    static let warningTextLA = "warning-text-di".localized()
    static let warningCountLA = "warning-count-di".localized()
    static let drivingTimeTextLA = "driving-time-text-di".localized()

    /// AfterFourWarningsView
    static let badDrivingNow = "bad-driving-now".localized()

    /// NormalDrivingView
    static let normalDrivingNow = "normal-driving-now".localized()

    /// SuddenAccelerationView, SuddenStopView
    static let suddenAcceleratedNow = "sudden-acceleration-now".localized()
    static let suddenDeceleratedNow = "sudden-stop-now".localized()
    static let countOneMoreWarning = "one-more-time".localized()
}
