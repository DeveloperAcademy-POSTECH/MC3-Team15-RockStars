//
//  String+Extension.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/25.
//

import Foundation

// MARK: - Localization Methods
extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(with argument: CVarArg = [], comment: String = "") -> String {
        return String(format: self.localized(comment: comment), argument)
    }
}

// MARK: - Image Names
extension String {
    /* Driving Pal View */
    static let backgroundBlueSky = "blueSky"
    static let backgroundAirport = "airport"
    static let palImage = "airplane"
    static let exit = "exit"
    static let startButtonImage = "startImage"
    static let setPhoneOnHolder = "setPhoneOnHolder"
    static let pouringLightning = "pouringLightning"
    static let gauge = "gauge"
    
    /* Result Analysis View */
    static let palImageInGoodResult = "resultPalImageGood"
    static let palImageInBadResult = "resultPalImageBad"
    static let backgroundInGoodResult = "resultBackgroundImageGood"
    static let backgroundInBadResult = "resultBackgroundImageBad"
    static let sfXmark = "xmark"
    static let sfShare = "square.and.arrow.up"
    
    /* Live Activity */
    static let palNormal = "normal"
    static let palWarning = "warning"
    
    static let circularWarning = "warningCircle"
    
    static let warnSignThunder = "warnSignThunder"
    static let warnSignMeteor = "warnSignMeteor"
    
    static let locationPinRed = "locationPinRed"
    static let locationPinBlue = "locationPinBlue"
    static let locationPinPink = "locationPinPink"
    static let locationPinYellow = "locationPinYellow"
    static let locationPinBlack = "locationPinBlack"
    
    static let lockScreen = "lockScreen"
    
    static let backgroundWarnSign =  "warnSignBackground"
}
