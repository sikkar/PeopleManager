//
//  Person.swift
//  People
//
//  Created by Angel Escribano on 15/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import ObjectMapper

struct Person: Mappable {
    
    var id : Int? = 0
    var name: String? = nil
    var birthdate: Date? = nil
    
    public init?(map: Map) {
    }
    
    public init(id: Int, name:String, birthDate: Date){
        self.id = id
        self.name = name
        self.birthdate = birthDate
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.birthdate <- (map["birthdate"], DateTransform())
    }
    
}
