//
//  ObjectModel.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit

enum ObjectType {
    case user
    case station
}


class ObjectModel:NSObject{
  
    var type: ObjectType?
   
    var title: String?
    
    var name: String?
    
    var coordinate: CLLocationCoordinate2D?
        
    var wifiSSID:String?
    
    var distance:Double = 0


    init(title:String, name:String, coordinate:CLLocationCoordinate2D, type:ObjectType, wifi: String)
    {
        
        self.title = title;
        
        self.name = name
        
        self.coordinate = coordinate
        
        self.type = type
        
        self.wifiSSID = wifi
        
    }
    

}
