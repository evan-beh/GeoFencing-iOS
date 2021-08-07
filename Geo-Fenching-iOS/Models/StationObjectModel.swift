//
//  StationObjectModel.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit

class StationObjectModel: ObjectModel {
    
    init(title:String, name:String, coordinate:CLLocationCoordinate2D, wifi: String)
    {
        super.init(title: title, name: name, coordinate: coordinate, type: ObjectType.station, wifi: wifi)
        
    }
}
