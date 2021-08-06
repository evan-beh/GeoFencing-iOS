//
//  ViewModel.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import CoreLocation

class ViewModel: NSObject {

    var petrolStations: [StationObjectModel]!
    
    public var locationDidRefresh: ((CLLocation, NSError?) -> ())!

    let locationService: LocationServiceProtocol
    let stationService: StationServiceProtocol


    init(locationService: LocationServiceProtocol = LocationService(), stationService:StationServiceProtocol = StationService() ) {
        
        self.locationService = locationService
        self.stationService = stationService


    }
  
    
    func startLocationEngine()
    {
        self.locationService.setup()
        self.locationService.fetchCurrentLocation { loc, error in
            self.locationDidRefresh(loc,error)
        }
        

    }
    
    func fetchStationData()
    {
        self.stationService.fetchStations { [weak self] (array,error) in
            self?.petrolStations = array
        }
        
    }

    func fetchStationAnnotationcomplete(fetchComplete: ([StationCMAnnotation], NSError?) -> ())
    {
        
        self.stationService.fetchStations { [weak self] (array,error) in
            self?.petrolStations = array
            
            var arAnnotation = [StationCMAnnotation]()
           
            for station in array{
                
                let object = StationCMAnnotation(object: station)
                
                arAnnotation.append(object)
            }
            
            fetchComplete(arAnnotation,nil)
            
        }
    }
    


    

}

