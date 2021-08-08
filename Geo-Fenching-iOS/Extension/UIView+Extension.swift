//
//  UIView+Extension.swift
//  Geo-Fenching-iOS
//
//  Created by Evan Beh on 06/08/2021.
//

import UIKit

extension UIView {

    func setRoundBorder()
    {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        
    }
    
    func setShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        
    }
  
}
