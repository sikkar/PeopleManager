//
//  PeopleManagerTests.swift
//  PeopleManagerTests
//
//  Created by Angel Escribano on 17/1/18.
//  Copyright © 2018 -. All rights reserved.
//

import XCTest
@testable import PeopleManager

class PeopleManagerTests: XCTestCase {
    
    var viewModel: PeopleViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = PeopleViewModel();
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFetchAllPeople() {
        let promise = expectation(description: "Get all people")
        viewModel?.requestAllPeople { error in
            if let _ = error {
                XCTFail()
            }
            if self.viewModel?.peopleList != nil{
                promise.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFakeService() {
        PeopleService.sharedInstance.fetchFakePerson { complete, person, error in
            XCTAssert(complete)
            XCTAssertNil(error)
            XCTAssertNotNil(person)
        }
    }
    
    func testFiltering(){
        let person1 = Person.init(name: "Roberto", birthDate: Date())
        let person2 = Person.init(name: "Maria", birthDate: Date())
        viewModel?.peopleList = [person1, person2]
        viewModel?.filteredPersonList = [person1, person2]
        viewModel?.filterPeopleListByName(name:"Roberto")
        XCTAssertNotEqual(viewModel?.filteredPersonList.count, viewModel?.peopleList.count)
    }
}

extension PeopleService {
    
    func fetchFakePerson(complete: @escaping (Bool, Person, PeopleError?) -> ()) {
        complete(true, Person.init(name: "Ang", birthDate: Date()),nil)
    }
}
