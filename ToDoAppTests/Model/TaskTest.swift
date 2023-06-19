//
//  TaskTest.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 24.05.2023.
//

import XCTest
@testable import ToDoApp

final class TaskTest: XCTestCase {

    func testInitTaxhWihtTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func testInitTaxhWihtTitleAndDescripiton () {
        let task = Task(title: "Foo", description: "Bar")
    
        XCTAssertNotNil(task)
    }
 
    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func testWhenGivenDescriptionSetsDescrtiption() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertEqual(task.description, "Bar")
    }
    
    func testTaskInitsWithDate() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLicationSetsLication() {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar",
                        description: "Baz",
                        location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 43)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let locationDict: [String : Any] = ["name" : "Baz"]
        let dictionary: [String: Any] = [
            "title" : "Foo",
            "description" : "Bar",
            "date" : date,
            "location" : locationDict
        ]
        
        let createdTask = Task(dict: dictionary)
        
        XCTAssertEqual(task, createdTask)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let location = Location(name: "Baz")
        let date = Date(timeIntervalSince1970: 43)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let generatedTask = Task(dict: task.dict)
        
        XCTAssertEqual(task, generatedTask )
    }
    
}
