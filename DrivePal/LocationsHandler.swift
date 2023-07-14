//
//  LocationsHandler.swift
//  DrivePal
//
//  Created by Gucci on 2023/07/14.
//

import SwiftUI
import CoreLocation
import OSLog

class LocationsHandler: NSObject, ObservableObject {
    private let locationManager: CLLocationManager
    private let logger = Logger()
    
    private var lastLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var kilometerPerHour = 0.0
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate =  self
        locationManager.requestWhenInUseAuthorization()
        //TODO: - 백그라운드 scenePhase에 따라서 업데이트
        locationManager.startUpdatingLocation()
    }
}

extension LocationsHandler: CLLocationManagerDelegate {
    private func processLocation(_ current: CLLocation) {
        guard let lastLocation else {
            lastLocation = current
            return
        }
        var speed = current.speed
        if speed < 0 {
            speed = lastLocation.distance(from: current) / (current.timestamp.timeIntervalSince(lastLocation.timestamp))
        }
        kilometerPerHour = speed * 3.6
        print(speed)
        self.lastLocation = current
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let newLocation = locations.last {
//            lastLocation = newLocation
//        }
        for location in locations {
            processLocation(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("error: \(error.localizedDescription)")
    }
}

// MARK: - 속도 계산을 위한 메서드와 백그라운드 동작 메서드
private extension LocationsHandler {
    func startBackgroundLocationUpdates() {
        self.locationManager = CLLocationManager()
        guard let locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    func caculateCurrentSpeed(_ current: CLLocation) {
        guard let lastLocation else {
            lastLocation = current
            return
        }
        guard current.speedAccuracy != -1 else { return }   // 속도 데이터 정확성 검사, -1이면 부정확
        
        var speed = current.speed
        if speed < 0 {
            /// speed가 0보다 작으면 유효하지 않은 데이터
            /// 그래서 직전 location을 이용해서 v = s * t 공식을 이용해 계산
            let distance = lastLocation.distance(from: current)
            let spendingTime = current.timestamp.timeIntervalSince(lastLocation.timestamp)
            speed = distance / spendingTime
        }
        self.lastLocation = current
        kilometerPerHour = Int(round(speed * 3.6 * 10) / 10)    // 소숫점 한 자리에서 반올림 0.1 까지의 정확도, 1의 자리부터 표현
    }
}
