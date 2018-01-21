//
//  DateHelper.swift
//  PeopleManager
//
//  Created by Angel Escribano on 19/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

extension Date {
    
    var dateToString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self)
    }
}
