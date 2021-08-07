//
//  UserInfoServices.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit
import MapKit

class UserInfoServices: NSObject {
    
    func fetchUserInfo(complete: @escaping (UserObjectModel, NSError?) -> ())
    {
        
        let user = UserObjectModel(title: "User", name: "John Doe", coordinate:CLLocationCoordinate2DMake(0, 0), wifi: "")

        complete(user,nil)
    }
  
}
