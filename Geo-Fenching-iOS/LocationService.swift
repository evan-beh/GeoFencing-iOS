//
//  LocationService.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationServiceProtocol
{
    func setup()
    
    func fetchCurrentLocation(complete: @escaping (CLLocation, NSError?) -> ())

}

class LocationService:NSObject, LocationServiceProtocol,CLLocationManagerDelegate {
  
  
 
    var locationManager: CLLocationManager!
    public var currentLocation: CLLocation?
    public var completeLoadLocation: ((CLLocation, NSError?) -> ())!

 
    
    func setup()
    {
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
              
        }
        
    }
    
    func fetchCurrentLocation(complete: @escaping (CLLocation, NSError?) -> ()) {
        completeLoadLocation = complete
    }
  
    
   
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { self.currentLocation = locations.last }

        if self.currentLocation == nil {
             // Zoom to user location
             if let userLocation = locations.last {
                
                self.completeLoadLocation(userLocation,nil)

             }
         }
     }
    
    
}

