//
//  Color.swift
//  PeopleManager
//
//  Created by Angel Escribano on 20/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func mainClearGray() -> UIColor {
        return UIColor(red: 220.0 / 255.0, green: 220.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    
    class func mainBlue() -> UIColor {
        return UIColor(red: 66.0 / 255.0, green: 191.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0)
    }
    
    class func dimmedGray() -> UIColor {
        let background = UIColor.gray
        return background.withAlphaComponent(0.4)
    }
}
