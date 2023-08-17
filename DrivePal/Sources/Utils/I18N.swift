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
    static let appLocale = "app-locale".localized()

    /* Button */
    static let buttonPopToRoot = "pop-to-root".localized()
    
    /* Authorization Request View */
    static let wordLocation = "word-location".localized()
    static let wordNotification = "word-notification".localized()
    static let locationDescription = "location-description".localized()
    static let notificationDescription = "notification-description".localized()
    static let authTitle = "auth-title".localized()
    static let essestialAuth = "essential-auth".localized()
    static let optionalAuth = "optional-auth".localized()
    static let btnSetAuth = "btn-set-authorization".localized()

    /* Velocity View */
    static let debugUpdateSuccess = "update-success".localized()
    static let debugUpdateFailure = "update-failure".localized()
    static let debugUpdateMessage = "update-message".localized()
    
    /* Main View */
    static let informDynamicIsland = "inform-dynamic-island".localized()
    
    /* Result View */
    static let wordsFromGoodResult = "words-from-good-result".localized()
    static let wordsFromBadResult = "words-from-bad-result".localized()
    
    static let wordsFromNoWarning = ["words-from-no-warning-result-1".localized(),
                                     "words-from-no-warning-result-2".localized(),
                                     "words-from-no-warning-result-3".localized()]

    // only sudden acceleration
    static let wordsFromOnlySuddenAcceleration = ["words-from-only-sudden-acceleration-1".localized(),
                                                 "words-from-only-sudden-acceleration-2".localized(),
                                                 "words-from-only-sudden-acceleration-3".localized()]

    // only sudden deceleration
    static let wordsFromOnlySuddenDeceleration = ["words-from-only-sudden-deceleration-1".localized(),
                                                  "words-from-only-sudden-deceleration-2".localized()]

    // both warnings
    static let wordsFromBothWarnings = ["words-from-both-warnings-1".localized(),
                                        "words-from-both-warnings-2".localized(),
                                        "words-from-both-warnings-3".localized()]
    
    static let wordSuddenAcceleration = "word-sudden-acceleration".localized()
    static let wordSuddenDeceleration = "word-sudden-deceleration".localized()
    static let wordRoadDrivingAnalysis = "word-road-driving-analysis".localized()
    static let wordAnalysisCriteria = "word-analysis-criteria".localized()

    /* Live Activity */
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
