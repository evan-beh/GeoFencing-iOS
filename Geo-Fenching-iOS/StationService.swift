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
        
                
        let station1 = StationObjectModel(title: "PETROL STAION", name: "JAYA ONE", coordinate: CLLocationCoordinate2DMake(3.1289662, 101.6141438))
        
        let station2 = StationObjectModel(title: "PETROL STAION", name: "PETRONAS Damansara Jaya 2 (Petronas)", coordinate: CLLocationCoordinate2DMake(3.1869496, 101.4961652))
        
        

        let station3 = StationObjectModel(title: "PETROL STAION", name: "Petronas SS 4B", coordinate: CLLocationCoordinate2DMake(3.1783373, 101.4884648))
        
        complete([station1,station2,station3], nil)
        
        

    }
    

}
