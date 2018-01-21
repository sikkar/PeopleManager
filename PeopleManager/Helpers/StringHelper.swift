//
//  StringHelper.swift
//  PeopleManager
//
//  Created by Angel Escribano on 21/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
