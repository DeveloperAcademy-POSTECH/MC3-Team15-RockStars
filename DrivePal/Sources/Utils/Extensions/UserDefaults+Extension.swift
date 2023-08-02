//
//  UserDefaults+extensions.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/11.
//

import Foundation

/*
View 내에서 @AppStorage로 접근하는 방법
```swift
@AppStorage("username", store: UserDefaults.shared) var username: String = "Anonymous"
```
해석: @AppStorage를 이용해서 username을 UserDefaults.shared에 저장할 거다.

Look for more info:
https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-appstorage-property-wrapper

Look for more info: https://eunjin3786.tistory.com/213
 */

// MARK: - App group 내에서 접근가능한 container 생성
extension UserDefaults {
    static var shared: UserDefaults {
        let bundleID = Bundle.main.bundleIdentifier ?? ""
        let appGroupIdentifier = "group" + bundleID
        return UserDefaults(suiteName: appGroupIdentifier) ?? UserDefaults.standard
    }
}
