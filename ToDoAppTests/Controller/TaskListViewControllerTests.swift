//
//  TaskListViewControllerTests.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 25.05.2023.
//

import XCTest
@testable import ToDoApp

final class TaskListViewControllerTests: XCTestCase {

    var sut: TaskListViewContoller!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: String(describing: TaskListViewContoller.self))
        
        sut = vc as? TaskListViewContoller
        
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenViewViewIsLoadedTabelViewNotNil() {
        
        XCTAssertNotNil(sut.tableView)
    }

    func testWhenViewIsLoadedDataProviderIsNotNil() {
           
           XCTAssertNotNil(sut.dataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateIsSet() {
        XCTAssertTrue(sut.tableView.delegate is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDataSoureIsSet() {
        XCTAssertTrue(sut.tableView.dataSource is DataProvider)
    }
    
    func testWhenViewIsLoadedTableViewDelegateEqualeTableViewDataSource() {
        XCTAssertEqual(sut.tableView.delegate as? DataProvider,
                       sut.tableView.dataSource as? DataProvider
        )
    }
    
}
