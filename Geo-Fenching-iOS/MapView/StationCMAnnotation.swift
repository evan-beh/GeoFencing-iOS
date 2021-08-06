//
//  StationCMAnnotation.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit

class StationCMAnnotation: CustomMapAnnotation {
    
    init(object:StationObjectModel) {

        super.init(object: object)
        self.imageName = "ic_station"



  }

}
