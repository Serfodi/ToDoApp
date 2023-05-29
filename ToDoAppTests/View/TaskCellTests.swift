//
//  TaskCellTests.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 26.05.2023.
//

import XCTest
@testable import ToDoApp

final class TaskCellTests: XCTestCase {
    
    var cell: TaskCell!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: String(describing: TaskListViewContoller.self)) as! TaskListViewContoller
        controller.loadViewIfNeeded()
        
        let tableView = controller.tableView
        let dataSoure = FakeDataSourse()
        tableView?.dataSource = dataSoure
        
        cell = tableView?.dequeueReusableCell(withIdentifier: String(describing: TaskCell.self), for: IndexPath(row: 0, section: 0)) as? TaskCell
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCellHasTitleLabel() {
        XCTAssertNotNil(cell.titleLabel)
    }
    
    func testCellHasTitleLabelInContentView() {
        XCTAssertTrue(cell.titleLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasLocationLabelInContentView() {
        XCTAssertTrue(cell.locationLabel.isDescendant(of: cell.contentView))
    }
    
    func testCellHasDataLabelInContentView() {
        XCTAssertTrue(cell.dataLabel.isDescendant(of: cell.contentView))
    }
    
    func testConfigerSetsTitle() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.titleLabel.text, task.title)
    }
    
    func testConfigerSetsDate() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        let df = DateFormatter()
        //    http://nsdateformatter.com
        df.dateFormat = "dd.MM.yy"
        let date = task.date
        let dateString = df.string(from: date)
        
        XCTAssertEqual(cell.dataLabel.text, dateString)
    }
    
    func testConfigerSetsLocation() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task)
        
        XCTAssertEqual(cell.locationLabel.text, task.location?.name )
    }
    
    
    func configureCellWithTask() {
        let task = Task(title: "Foo")
        cell.configure(withTask: task, done: true)
    }
    
    
    func testDoneTaskShouldStikeThrough() {
        configureCellWithTask()
        
        let attribueString = NSAttributedString(string: "Foo", attributes: [NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue])
        
        XCTAssertEqual(cell.titleLabel.attributedText, attribueString)
    }
    
    func testDoneTaskDateLabelEqualsNil() {
        configureCellWithTask()
        
        XCTAssertNil(cell.dataLabel)
    }
    
    func testLocationTaskDateLabelEqualsNil() {
        configureCellWithTask()
        
        XCTAssertNil(cell.locationLabel)
    }
    
    
}


extension TaskCellTests {
    
    class FakeDataSourse: NSObject, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return UITableViewCell()
        }

    }
    
}
