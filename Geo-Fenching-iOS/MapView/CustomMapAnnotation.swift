//
//  CustomMapAnnotation.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit
import Contacts



public class CustomMapAnnotation:NSObject, MKAnnotation {
    var imageName: String!
    public var coordinate: CLLocationCoordinate2D
    var object : ObjectModel?
    
    init(object:ObjectModel) {

        
    self.object = object
    self.coordinate = self.object?.coordinate ?? CLLocationCoordinate2D(latitude: 0,longitude: 0)
        super.init()


  }
    

 
  public var subtitle: String? {
    return self.object?.name
  }
   

  // Annotation right callout accessory opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    let addressDict = [CNPostalAddressStreetKey: subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = self.object?.title
    return mapItem
  }

}
