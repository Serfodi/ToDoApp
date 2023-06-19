//
//  LocationTest.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 24.05.2023.
//

import XCTest
import CoreLocation
@testable import ToDoApp

final class LocationTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testInitSetName() {
        let location = Location(name: "Foo")
        XCTAssertEqual(location.name, "Foo")
    }
    
    func testInitSetCoordinates() {
        let coordinate = CLLocationCoordinate2D(
            latitude: 1,
            longitude: 2)
        let location = Location(name: "Foo",
                                coordinate: coordinate )
        
        XCTAssertEqual(coordinate.longitude, location.coordinate?.longitude)
        XCTAssertEqual(coordinate.latitude, location.coordinate!.latitude)
    }

    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        
        let dict: [String : Any] = [
            "name" : "Foo",
            "latitude" : 10.0,
            "longitude" : 10.0
        ]
        
        let locationCreated = Location(dict: dict)
        
        XCTAssertEqual(location, locationCreated)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        
        let generatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, generatedLocation)
    }
    
}
