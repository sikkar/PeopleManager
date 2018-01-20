//
//  PeopleService.swift
//  PeopleManager
//
//  Created by Angel Escribano on 17/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

enum Endpoints: String {
    case base = "http://hello-world.innocv.com/api/user"
    case all = "/getall"
    case person = "/get/"
    case create = "/create"
    case update = "/update"
    case remove = "/remove/"
}

class PeopleService: NSObject {
    
    static let sharedInstance = PeopleService()
    
    fileprivate override init() {}
    
    func getPeople(completion: @escaping ([Person]) -> Void){
        let getAllUrl = Endpoints.base.rawValue + Endpoints.all.rawValue
        Alamofire.request(getAllUrl).responseArray(queue: DispatchQueue.global()) {(response: DataResponse<[Person]>) in
             if response.response?.statusCode == 200 {
                let peopleArray = response.result.value
                if let peopleArray = peopleArray {
                    completion(peopleArray)
                }
             } else {
                
            }
        }
    }
    
    func getPerson(personId:Int, completion: @escaping (Person) -> Void){
        let getPersonUrl = String.init(format: "%@%@%d", Endpoints.base.rawValue, Endpoints.person.rawValue, personId)
        Alamofire.request(getPersonUrl).responseObject(queue: DispatchQueue.global()) { (response: DataResponse<Person>) in
            if let person = response.result.value {
                completion(person)
            }
        }
    }
}
