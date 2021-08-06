//
//  CustomMapAnnotationView.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import Foundation
import MapKit


class CustomAnnotationView: MKAnnotationView {

  override var annotation: MKAnnotation? {
    willSet {
      guard let station = newValue as? CustomMapAnnotation else {return}

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,
        size: CGSize(width: 30, height: 30)))
      rightCalloutAccessoryView = mapsButton

      if let imageName = station.imageName {
        image = UIImage(named: imageName)
      } else {
        image = nil
      }

      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(13)
      detailLabel.text = station.subtitle
      detailCalloutAccessoryView = detailLabel
    }
  }

}

