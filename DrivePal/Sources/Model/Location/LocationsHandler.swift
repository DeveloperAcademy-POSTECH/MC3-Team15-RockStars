//
//  LocationsHandler.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/14.
//

import SwiftUI
import CoreLocation
import OSLog

enum AuthorizationStatus {
    case success
    case inProgress
    case failure
}

struct SpeedModel {
    let date: Date
    let kilometerPerHour: Int
    let location: CLLocation
}

@MainActor final class LocationsHandler: NSObject, ObservableObject {
    private lazy var locationManager: CLLocationManager? = nil
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: String(describing: LocationsHandler.self))

    var authorizationStatus: AuthorizationStatus {
        guard let status = locationManager?.authorizationStatus else { return .failure }
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .success
        case .notDetermined:
            return .inProgress
        case .denied, .restricted:
            return .failure
        }
    }
    
    @Published var motionStatus = MotionStatus.none
    var speedModel = SpeedModel(date: .now, kilometerPerHour: 0, location: .init()) {
        willSet {
            let speed = newValue.kilometerPerHour - speedModel.kilometerPerHour
            adjustMotionStatus(by: speed)
            objectWillChange.send()
        }
    }
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
    }
}

// MARK: - CLLocationManagerDelegate 시그니처 메서드
extension LocationsHandler: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            calculateCurrentSpeed(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("error: \(error.localizedDescription)")
    }
}

// MARK: - 속도 계산을 위한 메서드와 백그라운드 동작 메서드
extension LocationsHandler {
    private func startBackgroundLocationUpdates() {
        locationManager = CLLocationManager()
        guard let locationManager else { return }
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    private func calculateCurrentSpeed(_ current: CLLocation) {
        guard current.speedAccuracy != -1 else { return }   // 속도 데이터 정확성 검사, -1이면 부정확
        let lastLocation = speedModel.location
        var speed = current.speed
        if speed < 0 {
            /// speed가 0보다 작으면 유효하지 않은 데이터
            /// 그래서 직전 location을 이용해서 v = s * t 공식을 이용해 계산
            let distance = lastLocation.distance(from: current)
            let spendingTime = current.timestamp.timeIntervalSince(lastLocation.timestamp)
            speed = distance / spendingTime
        }
        let kilometerPerHour = Int(round(speed * 3.6 * 10) / 10)    // 소숫점 한 자리에서 반올림 0.1 까지의 정확도, 1의 자리부터 표현
        speedModel = SpeedModel(date: current.timestamp,
                            kilometerPerHour: kilometerPerHour,
                            location: current)
    }
    
    func requestAuthorization() {
        guard let locationManager else { return }
        if [CLAuthorizationStatus.authorizedAlways, .authorizedWhenInUse].contains(locationManager.authorizationStatus) {
            startBackgroundLocationUpdates()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    private func sleepThreadBriefly() {
        guard let locationManager else { return }
        stopUpdateSpeed()
        Thread.sleep(forTimeInterval: 5)
        updateSpeed()
    }
    
    private func adjustMotionStatus(by speed: Int) {
        if speed >= 11 {
            withAnimation { motionStatus = .suddenAcceleration }
            sleepThreadBriefly()
            logger.info("\(#function): Detact Sudden Acceleration")
            return
        } else if speed <= -7 {
            withAnimation { motionStatus = .suddenStop }
            sleepThreadBriefly()
            logger.info("\(#function): Detact Sudden Stop")
            return
        } else {
            withAnimation { motionStatus = .normal }
        }
    }
    
    func updateSpeed() {
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdateSpeed() {
        locationManager?.stopUpdatingLocation()
    }
}
