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
    public var currentLocation: CLLocation?

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
            
            self.currentLocation = loc
            self.locationDidRefresh(loc,error)
        }
        

    }
    
    func fetchStationData()
    {
        self.stationService.fetchStations { [weak self] (array,error) in
            self?.petrolStations = array
        }
        
    }

    func fetchStationAnnotation(fetchComplete: ([StationCMAnnotation], NSError?) -> ())
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
    
    func getUserAnnotation(fetchComplete: @escaping ([UserCMAnnotation], NSError?) -> ())
    {
        
        self.locationService.fetchCurrentLocation { loc, error in
            self.locationDidRefresh(loc,error)
            
            self.currentLocation = loc
            let user = UserObjectModel(title: "User", name: "John Doe", coordinate:loc.coordinate, wifi: "SSID123")
            let object = UserCMAnnotation(object: user)
            
            fetchComplete([object], nil)
            
        }
        
        
       

        
    }
    


    

}

