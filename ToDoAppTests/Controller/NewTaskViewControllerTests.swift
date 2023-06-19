//
//  NewTaskViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 29.05.2023.
//

import XCTest
import CoreLocation

import Intents
import Contacts

@testable import ToDoApp

final class NewTaskViewControllerTests: XCTestCase {

    var sut: NewTaskViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTitelTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }

    func testHaslocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasAdressTextField() {
        XCTAssertTrue(sut.adressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testSaveUsesGeocoderToConvertCoordinateFromAddress() {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        let date = df.date(from: "01.01.19")
        
        
        sut.titleTextField.text = "Foo"
        sut.locationTextField.text = "Bar"
        sut.dateTextField.text = "01.01.19"
        sut.adressTextField.text = "Москва"
        sut.descriptionTextField.text = "Baz"
        
        sut.taskManager = TaskManager()
        let mockGLGeocoder = MockGLGeocoder()
        sut.geocoder = mockGLGeocoder
        sut.save()
        
        let coordinate = CLLocationCoordinate2D(latitude: 55.7586642, longitude: 37.6192919)
        let location = Location(name: "Bar", coordinate: coordinate )
        let generatedTask = Task(title: "Foo", description: "Baz", date: date, location: location)
        
        let coordinate2 = CLLocation(latitude: 55.7586642, longitude: 37.6192919)
        let placemark = MockCLPlacemark(location: coordinate2, name: "Bar", postalAddress: nil)
        
        mockGLGeocoder.completionHandler?([placemark], nil)
        
        let task = sut.taskManager.task(at: 0)
        
        XCTAssertEqual(task, generatedTask)
    }
    
    
    func testSaveButtonHasSaveMetod() {
        let saveButton = sut.saveButton
        guard let action = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
            XCTFail()
            return
        }
        XCTAssertTrue(action.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoorditante() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let address = "Москва"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            guard
                let latitude = location?.coordinate.latitude,
                let longitude = location?.coordinate.longitude else {
                XCTFail()
                return
            }
        
            XCTAssertEqual(latitude, 55.7586642)
            XCTAssertEqual(longitude, 37.6192919)
            geocoderAnswer.fulfill()
        }
        waitForExpectations(timeout: 5)
    }
    
    
    func testSaveDismissNewTaskViewController() {
        var mockVC = MockNewTaskViewController()
        mockVC.titleTextField = UITextField()
        mockVC.titleTextField.text = "Foo"
        mockVC.descriptionTextField = UITextField()
        mockVC.descriptionTextField.text = "Baz"
        mockVC.dateTextField = UITextField()
        mockVC.dateTextField.text = "01.01.19"
        mockVC.adressTextField = UITextField()
        mockVC.adressTextField.text = "Москва"
        mockVC.locationTextField = UITextField()
        mockVC.locationTextField.text = "Bar"
        
        mockVC.save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertTrue(mockVC.isDismissed)
        }
    }
    
    
}


extension NewTaskViewControllerTests {
    
    class MockGLGeocoder: CLGeocoder {
        
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {}
    
}

extension NewTaskViewControllerTests {
    class MockNewTaskViewController: NewTaskViewController {
        var isDismissed = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
        
    }
}
