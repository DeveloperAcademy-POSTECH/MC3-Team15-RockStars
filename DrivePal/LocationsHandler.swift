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
