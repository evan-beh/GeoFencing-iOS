//
//  ViewModel.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork

class ViewModel: NSObject {

    let constRadius:Double = 500

    var petrolStations: [StationObjectModel]!
    var userInfoObject: ObjectModel?
    
    var userAnnotation: UserCMAnnotation?

    public var currentLocation: CLLocation?
    
    

    public var locationDidRefresh: ((CLLocation, NSError?) -> ())!

    let locationService: LocationServiceProtocol
    let stationService: StationServiceProtocol
    let wifiService: WiFIInfoServiceProtocol
    let userInfoServices: UserInfoServices


    init(locationService: LocationServiceProtocol = LocationService(),
         stationService:StationServiceProtocol = StationService(),
         wifiService:WiFIInfoServiceProtocol = MockWifiInfoService(),
         userInfoServices:UserInfoServices = UserInfoServices()) {
        
        self.locationService = locationService
        self.stationService = stationService
        self.wifiService = wifiService
        self.userInfoServices = userInfoServices


    }
  
    
    func startLocationEngine()
    {
        self.locationService.setup()
        fetchCurrentLocation()
        

    }
    
    func fetchCurrentLocation()
    {
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
    
    func getUserAnnotation(fetchComplete: @escaping (UserCMAnnotation, NSError?) -> ())
    {
        
        self.userInfoServices.fetchUserInfo { userInfo, error in
            
            // if error will need to handle seperately
            let user = userInfo
            user.coordinate = self.currentLocation?.coordinate
            self.userInfoObject = user
            let object = UserCMAnnotation(object: user)
            self.userAnnotation = object
            fetchComplete(object, nil)

        }
        
    }
    
 
  
}
//Validation of user and station distance
extension ViewModel
{
    
    func validateInRangeAndWifi(station:StationObjectModel, user:UserObjectModel) -> (Bool,Bool)
    {
        
        let userWifiSSID = self.wifiService.getWiFiSsid()
        
        let userLocation = CLLocation.init(latitude: self.currentLocation!.coordinate.latitude, longitude: self.currentLocation!.coordinate.longitude)

        let petrolLocation = CLLocation.init(latitude: (station.coordinate!.latitude), longitude: (station.coordinate!.longitude))
              
        let distance =  petrolLocation.distance(from: userLocation)
              
        return (distance <= constRadius, station.wifiSSID == userWifiSSID)

        
                
    }
}

