//
//  PeopleService.swift
//  PeopleManager
//
//  Created by Angel Escribano on 17/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class PeopleService {
    
    static let sharedInstance = PeopleService()
    let headers: [String:String] = ["Accept": "application/json"]
    
}
