//
//  StationService.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit

protocol StationServiceProtocol
{
    
    func fetchStations(complete: ([StationObjectModel], NSError?) -> ())

}

class StationService: NSObject,StationServiceProtocol {
    func fetchStations(complete: ([StationObjectModel], NSError?) -> ()) {
        
        
//        let user = UserObjectModel(title: "this is a Setel user", name: "Jason", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), wifi: "")
        
        let station1 = StationObjectModel(title: "Station A", name: "TTDI", coordinate: CLLocationCoordinate2D(latitude: 0,longitude: 0))
        
        
        let station2 = StationObjectModel(title: "Station A", name: "TTDI", coordinate: CLLocationCoordinate2D(latitude: 0,longitude: 0))
        
        
        let station3 = StationObjectModel(title: "Station A", name: "TTDI", coordinate: CLLocationCoordinate2D(latitude: 0,longitude: 0))
        
        
        complete([station1,station2,station3], nil)
        
        

    }
    

}
