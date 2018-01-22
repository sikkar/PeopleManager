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
    case base = "https://hello-world.innocv.com/api/user"
    case all = "/getall"
    case person = "/get/"
    case create = "/create"
    case update = "/update"
    case remove = "/remove/"
}

class PeopleService: NSObject {
    
    static let sharedInstance = PeopleService()
    
    fileprivate override init() {}
    
    func getPeople(completion: @escaping ([Person]?, PeopleError?) -> Void){
        let getAllUrl = Endpoints.base.rawValue + Endpoints.all.rawValue
        Alamofire.request(getAllUrl).responseArray(queue: DispatchQueue.global()) {(response: DataResponse<[Person]>) in
            if self.handleResponse(statusCode: (response.response?.statusCode)!){
                let peopleArray = response.result.value
                if let peopleArray = peopleArray {
                    completion(peopleArray, nil)
                }
            } else {
                completion(nil, PeopleError(message:"ERROR_RETRIEVING_ALL".localized, errorCode: String(describing: response.response!.statusCode)))
            }
        }
    }
    
    func getPerson(personId:Int, completion: @escaping (Person?, PeopleError?) -> Void) {
        let getPersonUrl = String.init(format: "%@%@%d", Endpoints.base.rawValue, Endpoints.person.rawValue, personId)
        Alamofire.request(getPersonUrl).responseObject(queue: DispatchQueue.global()) { (response: DataResponse<Person>) in
            if self.handleResponse(statusCode: (response.response?.statusCode)!) {
                if let person = response.result.value {
                    completion(person, nil)
                }
            } else {
                completion(nil, PeopleError(message: "ERROR_RETRIEVING_SINGLE".localized, errorCode:String(describing: response.response!.statusCode)))
            }
        }
    }
    
    func addPerson(person: Person, completion: @escaping (Person?, PeopleError?) -> Void) {
        let addPersonUrl = String.init(format: "%@%@", Endpoints.base.rawValue, Endpoints.create.rawValue)
        Alamofire.request(addPersonUrl, method: .post, parameters: person.toJSON(), encoding: JSONEncoding.default, headers: ["Accept": "application/json"])
            .responseObject { (response: DataResponse<Person>) in
                if self.handleResponse(statusCode: (response.response?.statusCode)!){
                    if let person = response.result.value {
                        completion(person, nil)
                    }
                } else {
                    completion(nil, PeopleError(message: "ERROR_ADDING_PERSON".localized, errorCode:String(describing: response.response!.statusCode)))
                }
        }
    }
    
    func updatePerson(person: Person, completion: @escaping (Person?, PeopleError?) -> Void) {
        let updatePersonUrl = String.init(format:"%@%@", Endpoints.base.rawValue, Endpoints.update.rawValue)
        Alamofire.request(updatePersonUrl, method: .post, parameters: person.toJSON(), encoding: JSONEncoding.default, headers: ["Accept": "application/json"])
            .responseObject { (response: DataResponse<Person>) in
                if self.handleResponse(statusCode: (response.response?.statusCode)!){
                    if let person = response.result.value {
                        completion(person, nil)
                    }
                } else {
                    completion(nil, PeopleError(message: "ERROR_UPDATING_PERSON".localized, errorCode:String(describing: response.response!.statusCode)))
                }
        }
    }
    
    func deletePerson(personId: Int, completion: @escaping (PeopleError?) ->Void) {
        let removePersonUrl = String.init(format:"%@%@%d",Endpoints.base.rawValue, Endpoints.remove.rawValue, personId)
        Alamofire.request(removePersonUrl).responseData { response in
            if self.handleResponse(statusCode: (response.response?.statusCode)!) {
                completion(nil)
            } else {
                completion(PeopleError(message: "ERROR_DELETING_PERSON".localized, errorCode: String(describing:response.response!.statusCode)))
            }
        }
    }
    
    func handleResponse(statusCode: Int) -> Bool {
        switch statusCode {
        case 200...210:
            return true
        default:
            return false
        }
    }
    
}
