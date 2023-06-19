//
//  DataProviderTests.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 25.05.2023.
//

import XCTest
@testable import ToDoApp

final class DataProviderTests: XCTestCase {

    var sut: DataProvider!
    var tableView: UITableView!
    var controller: TaskListViewContoller!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DataProvider()
        sut.taskManager = TaskManager()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = storyboard.instantiateViewController(identifier: String(describing: TaskListViewContoller.self)) as? TaskListViewContoller
        
        controller.loadViewIfNeeded()
        
        tableView = controller.tableView
        tableView.dataSource = sut
        tableView.delegate = sut
    }

    override func tearDownWithError() throws {
        sut.taskManager?.removeAll()
        try super.tearDownWithError()
    }

    func testNumberOfSectionIsTwo() {
        let numberOfSections = tableView.numberOfSections
        
        XCTAssertEqual(numberOfSections, 2)
    }

    func testNumberOfRowsInSectionZeroIsTasksCount() {
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 2)
    }
    
    func testNumberOfRowsInSectionOneIsDoneTasksCount() {
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        sut.taskManager?.chekTask(at: 0)
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 1)
        
        sut.taskManager?.add(task: Task(title: "Bar"))
        sut.taskManager?.chekTask(at: 0)
        
        tableView.reloadData()
        
        XCTAssertEqual(tableView.numberOfRows(inSection: 1), 2)
    }
    
    func testCellForRowAtIndexPathReturntTaskCell() {
        sut.taskManager?.add(task: Task(title: "Foo"))
        
        tableView.reloadData()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(cell is TaskCell)
    }
    
    func testCellForRowAtIndexPathDequeuesCellFromTableView() {
        let mocTableView = MockTableView.mockTableView(withDataSourse: sut)
        
        sut.taskManager?.add(task: Task(title: "Foo"))
        mocTableView.reloadData()
        
        _ = mocTableView.cellForRow(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(mocTableView.cellIsDequeued)
    }
    
    
    func testCellForRowInSectionZeroCellsConfigure() {
        let mocTableView = MockTableView.mockTableView(withDataSourse: sut)
        
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        mocTableView.reloadData()
        
        let cell = mocTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }

    func testCellForRowInSectionOneCellsConfigure() {
        let mocTableView = MockTableView.mockTableView(withDataSourse: sut)
        
        let task = Task(title: "Foo")
        let taskTwo = Task(title: "Bar")
        sut.taskManager?.add(task: task)
        sut.taskManager?.add(task: taskTwo)
        sut.taskManager?.chekTask(at: 0)
        mocTableView.reloadData()
        
        let cell = mocTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! MockTaskCell
        
        XCTAssertEqual(cell.task, task)
    }
    
    
    func testDeleteButtonTitleSectionZeroShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(buttonTitle, "Done")
    }
    
    func testDeleteButtonTitleSectionOneShowsDone() {
        let buttonTitle = tableView.delegate?.tableView?(tableView, titleForDeleteConfirmationButtonForRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(buttonTitle, "Undone")
    }
    
    func testCheckingTaskChecksInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 0)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 1)
    }
    
    
    func testUncheckingTasckUnckekisInTaskManager() {
        let task = Task(title: "Foo")
        sut.taskManager?.add(task: task)
        sut.taskManager?.chekTask(at: 0)
        tableView.reloadData()
        
        tableView.dataSource?.tableView?(
            tableView,
            commit: .delete,
            forRowAt: IndexPath(row: 0, section: 1))
        
        XCTAssertEqual(sut.taskManager?.tasksCount, 1)
        XCTAssertEqual(sut.taskManager?.doneTasksCount, 0)
    }
     
    
}

extension DataProviderTests {
    
    class MockTableView: UITableView {
        var cellIsDequeued = false
        
        static func mockTableView(withDataSourse dataSoure: UITableViewDataSource) -> MockTableView {
            let mocTableView = MockTableView(frame: CGRect(x: 0, y: 0, width: 375, height: 658), style: .plain)
            mocTableView.dataSource = dataSoure
            mocTableView.register(MockTaskCell.self, forCellReuseIdentifier: String(describing: TaskCell.self))
            return mocTableView
        }
        
        override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
            cellIsDequeued = true
            
            return super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        }
    }
 
    
    class MockTaskCell: TaskCell {
        
        var task: Task?
        
        override func configure(withTask task: Task, done: Bool = false) {
            self.task = task
        }
        
    }
    
}

