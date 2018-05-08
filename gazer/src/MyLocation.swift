//
//  GetLocation.swift
//  gazer
//
//  Created by LeGal on 2018/05/05.
//  Copyright © 2018年 OCTA. All rights reserved.
//

import Foundation
import CoreLocation

class MyLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    func getLocation() {
        setupLocationManager()
    }
    
    func setupLocationManager() {
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            locationManager.delegate = self
            locationManager.distanceFilter = 10
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        
        print("latitude: \(latitude!)\nlongitude: \(longitude!)")
    }
}
