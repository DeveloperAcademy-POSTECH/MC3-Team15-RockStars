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

final class LocationsHandler: NSObject, ObservableObject {
    private lazy var locationManager: CLLocationManager? = nil
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "",
                                category: String(describing: LocationsHandler.self))
    private var isWriteEnabled = true
    
    static let shared = LocationsHandler()
    private let locale = Locale(identifier: I18N.appLocale)
    private let geoCoder = CLGeocoder()
    
    @Published var authorizationStatus = AuthorizationStatus.inProgress
    @Published var address = ""
    private var isAnimated = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    var motionStatus = MotionStatus.none {
        willSet {
            guard isWriteEnabled else { return }
            if newValue == .landing {
                stopUpdateSpeed()
            }
            if newValue == .normal {
                updateSpeed()
            }
            objectWillChange.send()
        }
    }
    
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
        updateAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate 시그니처 메서드
extension LocationsHandler: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            calculateCurrentSpeed(location)
        }
        
        Task.detached { @MainActor [weak self] in
            if let loadedAddress = try? await self?.getCurrentAddress(locations.last?.coordinate) {
                self?.address = loadedAddress
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("error: \(error.localizedDescription)")
    }
}

// MARK: - 속도 계산을 위한 메서드와 백그라운드 동작 메서드
extension LocationsHandler {
    
    private func startBackgroundLocationUpdates() {
        guard let locationManager else { return }
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        updateSpeed()
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
            updateSpeed()
        }
    }
    
    private func sleepThreadBriefly() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isAnimated = false
            withAnimation { self.motionStatus = .normal }
        }
    }
    
    private func adjustMotionStatus(by speed: Int) {
        guard motionStatus != .none else { return }
        guard motionStatus != .takingOff else { return }
        guard !self.isAnimated else { return }
        if speed >= 11 {
            isAnimated = true
            withAnimation { motionStatus = .suddenAcceleration }
            sleepThreadBriefly()
            logger.info("\(#function): Detact Sudden Acceleration")
            return
        } else if speed <= -7 {
            isAnimated = true
            withAnimation { motionStatus = .suddenStop }
            sleepThreadBriefly()
            logger.info("\(#function): Detact Sudden Stop")
            return
        } else {
            withAnimation { motionStatus = .normal }
        }
    }
    
    func updateAuthorization() {
        guard let manager = locationManager else {
            authorizationStatus = .failure
            return
        }
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startBackgroundLocationUpdates()
            return authorizationStatus = .success
        case .notDetermined:
            return authorizationStatus = .inProgress
        case .denied, .restricted:
            return authorizationStatus = .failure
        @unknown default:
            return authorizationStatus = .failure
        }
    }
    
    func updateSpeed() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }
    }
    
    func stopUpdateSpeed() {
        locationManager?.stopUpdatingLocation()
    }
    
    private func getCurrentAddress(_ location: CLLocationCoordinate2D?) async throws -> String {
        guard let position = location else { return "" }
        let location: CLLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        
        var currentAddress = ""
        guard let marker = try await geoCoder.reverseGeocodeLocation(location, preferredLocale: locale).first
            else { return "" }
        
        if let administrativeArea = marker.administrativeArea {
            currentAddress += administrativeArea + " "
        }
        if let locality = marker.locality {
            currentAddress += locality + " "
        }
        if let subLocality = marker.subLocality {
            currentAddress += subLocality + " "
        }
        if let subThoroughfare = marker.subThoroughfare {
            currentAddress += subThoroughfare + " "
        }
        return currentAddress
    }
}
