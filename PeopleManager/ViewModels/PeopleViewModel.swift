//
//  PeopleViewModel.swift
//  PeopleManager
//
//  Created by Angel Escribano on 17/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class PeopleViewModel: NSObject {

    var peopleList: [Person] = []
    var filteredPersonList: [Person] = []
    
    required override init() {
        
    }
    
    func requestAllPeople(completionHandler: @escaping((PeopleError?) -> Void)){
        PeopleService.sharedInstance.getPeople{ [weak self] peopleArray, error in
            guard let strongSelf = self else {return}
            if let peopleError = error {
                completionHandler(peopleError)
            } else {
                if let people = peopleArray {
                    strongSelf.peopleList = people
                    for _ in 1...10 {
                       strongSelf.peopleList.append(Person.init(name: "Angel", birthDate: Date()))
                        strongSelf.peopleList.append(Person.init(name: "Leonardo", birthDate: Date()))
                    }
                    completionHandler(nil)
                }
            }
        }
    }
    
    func requestAddPerson(name: String, birthdate: Date, completionHandler: @escaping ((PeopleError?) -> Void)){
        let person = Person.init(name: name, birthDate: birthdate)
        PeopleService.sharedInstance.addPerson(person: person) { person, error  in
            if let addError = error {
                completionHandler(addError)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func requestDeletePerson(personId: Int, completionHandler: @escaping ((PeopleError?) -> Void)){
        PeopleService.sharedInstance.deletePerson(personId: personId) { error in
            if let removeError = error{
                completionHandler(removeError)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func requestUpdatePerson(person: Person, completionHandler: @escaping ((PeopleError?) -> Void)){
        PeopleService.sharedInstance.updatePerson(person: person) { person, error in
            if let updateError = error {
                completionHandler(updateError)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func filterPeopleListByName(name: String){
        filteredPersonList = peopleList.filter { person -> Bool in
            return (person.name?.lowercased().contains(name.lowercased()))!
        }
    }
}
