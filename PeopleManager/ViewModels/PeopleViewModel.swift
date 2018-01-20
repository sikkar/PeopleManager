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
    
    required override init() {
        
    }
    
    func requestAllPeople(completionHandler: @escaping(() -> Void)){
        PeopleService.sharedInstance.getPeople{ [weak self] peopleArray in
            guard let strongSelf = self else {return}
            strongSelf.peopleList = peopleArray
            for _ in 1...15 {
                strongSelf.peopleList += peopleArray
            }
            completionHandler()
        }
    }
    
}
