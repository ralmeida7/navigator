//
//  LocationManager.swift
//  Logistics2
//
//  Created by Roberto Almeida on 5/12/20.
//  Copyright © 2020 Roberto Almeida. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class LocationManager: NSObject {
        
    private let clLocationManager = CLLocationManager()
    static let shared = LocationManager()
    private let taskStorage = TaskStorage.shared;
    var location: CLLocation? = nil
    var course: Double?
    var speed: Double?
    var first = true
    var task: Task?
    
    override init() {
        super.init();
        clLocationManager.delegate = self;
        clLocationManager.desiredAccuracy =  kCLLocationAccuracyBest
        clLocationManager.distanceFilter = kCLDistanceFilterNone
        clLocationManager.allowsBackgroundLocationUpdates = true
        clLocationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoring(task: Task) {
        self.task = task
        clLocationManager.startUpdatingLocation()
    }
    
    func stopMonitoring() {
        self.task = nil
        clLocationManager.stopUpdatingLocation()
    }
        
}

extension LocationManager: CLLocationManagerDelegate {
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
//        if ( location.speed < 4 ) {
//            return
//        }

        print("lat: \(location.coordinate.latitude), lon: \(location.coordinate.longitude)")
//        if ( !first ) {
//            if let _ = self.locations.first(where: { $0.coordinate.latitude == location.coordinate.latitude
//                                                && $0.coordinate.longitude == location.coordinate.longitude }) {
//                print("Finalizando status update 2")
//                print(self.coordinates)
//                print(self.locations)
//                clLocationManager.stopUpdatingLocation()
//                return
//            }
//        }
        self.location = location
//        if ( first ) {
//            print(self.locations)
//        }
        self.course = location.course
        self.speed = location.speed
        first = false
        taskStorage.saveLocation(task: task!, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, course: location.course, speed: location.speed, date: Date())
    }
    
    
}
