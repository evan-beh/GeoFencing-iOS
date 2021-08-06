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
        
   
    init(title:String, name:String, coordinate:CLLocationCoordinate2D, type:ObjectType)
    {
        
        self.title = title;
        
        self.name = name
        
        self.coordinate = coordinate
        
        self.type = type
        
    }
    

}
