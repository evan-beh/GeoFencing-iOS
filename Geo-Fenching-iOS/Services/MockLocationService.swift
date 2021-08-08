//
//  MockLocationService.swift
//  Geo-Fenching-iOSTests
//
//  Created by Evan Beh on 08/08/2021.
//

import UIKit
import MapKit
import CoreLocation

class MockLocationService:NSObject, LocationServiceProtocol {
  
    func setup() {
        print("for testing purposes")
    }
    
    func fetchCurrentLocation(complete: @escaping (CLLocation, NSError?) -> ()) {
        
        
//
//        //Nearby Jaya One
//        let myLocation = CLLocation(latitude: 3.1184089, longitude: 101.6332484)
//
//        //Columbia
//        let myLocation = CLLocation(latitude: 3.1182974, longitude: 101.6352253)

        //PETRONAS Damansara Jaya 2
        let myLocation = CLLocation(latitude: 3.1869496, longitude: 101.4961652)

        complete (myLocation,nil)
        
    }
    
    
   

}
