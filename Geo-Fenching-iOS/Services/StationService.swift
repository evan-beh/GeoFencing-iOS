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

        
        let station1 = StationObjectModel(title: "PETROL STAION", name: "COLUMBIA", coordinate: CLLocationCoordinate2DMake(3.1182974, 101.6352253), wifi: "123456")

        let station2 = StationObjectModel(title: "PETROL STAION", name: "SinChew Daily", coordinate: CLLocationCoordinate2DMake(3.1173352, 101.628239), wifi: "222222")
        
        
        let station3 = StationObjectModel(title: "PETROL STAION", name: "Petronas SS 4B", coordinate: CLLocationCoordinate2DMake(3.1080823, 101.6045678), wifi: "123456")
        
        complete([station1,station2,station3], nil)
        

    }
    

}
