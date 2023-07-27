//
//  Bundle+Extension.swift
//  DrivePal
//
//  Created by 제나 on 2023/07/18.
//

import Foundation

extension Bundle {
    var backgroundTaskIdentifier: String {
        guard let dictionary = Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? [String] else { fatalError("BGTaskIdentifier 오류") }
        return dictionary[0]
    }
}
