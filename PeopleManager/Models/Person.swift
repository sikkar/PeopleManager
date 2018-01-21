//
//  Person.swift
//  People
//
//  Created by Angel Escribano on 15/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import ObjectMapper

struct Person: Mappable {
    
    var id : Int?
    var name: String?
    var birthdate: Date?
    
    public init?(map: Map) {
    }
    
    public init(name:String, birthDate: Date){
        self.name = name
        self.birthdate = birthDate
    }
    
    mutating func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.birthdate <- (map["birthdate"], CustomDateFormatTransform.init(formatString: "yyyy-MM-dd'T'HH:mm:ss"))
    }
    
}
