//
//  ViewModel.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import CoreLocation
import SystemConfiguration.CaptiveNetwork
import PromiseKit

class ViewModel: NSObject {

    @Published var nearestStation: StationObjectModel?
    
    var distanceFromUser:Double = 0

    let constRadius:Double = 500

    var petrolStations: [StationObjectModel]!

    var userInfoObject: ObjectModel?
    
    var userAnnotation: UserCMAnnotation?

    public var currentLocation: CLLocation?
    

    public var locationDidRefresh: ((CLLocation, NSError?) -> ())!

    
    //Demo of closure binding
    var updateUI:()->Void={}

    
    
    let locationService: LocationServiceProtocol
    let stationService: StationServiceProtocol
    let wifiService: WiFIInfoServiceProtocol
    let userInfoServices: UserInfoServices


    public var enablePump :Bool {
        didSet {
            updateUI()
        }
    }
    
    init(locationService: LocationServiceProtocol = LocationService(),
         stationService:StationServiceProtocol = StationService(),
         wifiService:WiFIInfoServiceProtocol = MockWifiInfoService(),
         userInfoServices:UserInfoServices = UserInfoServices()) {
        
        self.locationService = locationService
        self.stationService = stationService
        self.wifiService = wifiService
        self.userInfoServices = userInfoServices
        self.enablePump = false
        

    }


    func startLocationService() -> Promise<Any?>
    {
        
        let promise = Promise<Any?> {seal in
            
            self.locationService.setup()
            seal.fulfill(nil)
        }
        
        return promise
        
    }
    
    func retreivePageData() -> Promise<Any?>
    {
        
        let promise = Promise<Any?> {seal in
            
            self.fetchCurrentLocation()
            self.fetchStationData()
            self.fetchUserInfo()
            
            seal.fulfill(nil)

        }
        
       return promise

        
    }
    
    func fetchCurrentLocation()  -> Promise<CLLocation>
    {
        let promise = Promise<CLLocation> { seal in
            self.locationService.fetchCurrentLocation { loc, error in
                  
                self.currentLocation = loc
                
                if (error != nil)
                {
                    seal.reject(NSError(domain: "1", code: 2, userInfo: ["reason": "retreive data failed"]))
                }

                else{
                    self.locationDidRefresh(loc,error)
                    seal.fulfill(loc)

                }
              }
         }

      return promise
        
    }
    
    func fetchUserInfo() -> Promise <UserObjectModel>
    {
        
        let promise = Promise<UserObjectModel> { seal in
            
            if ((self.userInfoObject) != nil)
            {
                seal.fulfill(self.userInfoObject! as! UserObjectModel)
            }
            else{
                
                self.userInfoServices.fetchUserInfo { userInfo, error in
                    if (error != nil)
                    {
                        //TO DO : setup error code
                    }
                    else{
                        
                        self.userInfoObject = userInfo
                        
                        seal.fulfill(userInfo)

                    }
           
                }
           
            }
      
    }
        
        return promise
    }
  
        
    func fetchStationData() -> Promise <Any>
    {
        

        let promise = Promise <Any> {seal in
            
            self.stationService.fetchStations { [weak self] (array,error) in
                self?.petrolStations = array

                seal.fulfill(array)
            }
        }
        
        return promise
        
    }

    func fetchStationAnnotation() -> Promise<[StationCMAnnotation]>
    {
        
        let promise = Promise<[StationCMAnnotation]> {seal in
            
            if (!self.petrolStations.isEmpty)
            {
                var arAnnotation = [StationCMAnnotation]()
                for station in self.petrolStations{
                    
                    let object = StationCMAnnotation(object: station)
                    arAnnotation.append(object)
                }
                seal.fulfill(arAnnotation)
                
            }
            else{
                
                seal.reject(NSError(domain: "1", code: 2, userInfo: ["reason": "retreive data failed"]))
            }
        }
        
        return promise
        
       
    }
    
    func getUserAnnotation(completion: @escaping (UserCMAnnotation, NSError?) -> ())
    {
        firstly {
                
                self.fetchUserInfo()
                
        }.done { user in
                                
            user.coordinate = self.currentLocation?.coordinate
                
            let object = UserCMAnnotation(object: user)
                
            self.userAnnotation = object
            
            completion(object,nil)
                
        }
        
    }
    

    func getNearestStation()
    {
        var distance:Double  = 0.0
        var nearest = 0
         
        if let loc = self.currentLocation
        {
            let userLocation = CLLocation.init(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)

            
            
            for (index, station) in self.petrolStations.enumerated() {
                
                let stationLocation = CLLocation.init(latitude: (station.coordinate!.latitude), longitude: (station.coordinate!.longitude))

                let tempDistance =  stationLocation.distance(from: userLocation)
              
                if Double(tempDistance) < Double(distance) || index == 0
                {
                    distance = tempDistance
                    nearest = index
                }
              
            }
            
            let station = self.petrolStations[nearest]
            station.distance = distance
            self.nearestStation = station
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

