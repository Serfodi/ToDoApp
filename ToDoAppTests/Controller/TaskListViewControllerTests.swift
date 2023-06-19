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
        try super.setUpWithError()
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
    
    func testTaskVCHasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? TaskListViewContoller, sut)
    }
    
    
    func presentVC() -> NewTaskViewController {
        guard
            let newTaskButton = sut.navigationItem.rightBarButtonItem,
            let action = newTaskButton.action else {
            return NewTaskViewController()
        }
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.performSelector(onMainThread: action, with: newTaskButton, waitUntilDone: true)
        
        let newTaskViewController = sut.presentedViewController as! NewTaskViewController
        return newTaskViewController
    }
    
    func testAddNewTaskPresentNewTaskViewController() {
        let newTaskViewController = presentVC()
        XCTAssertNotNil(newTaskViewController.titleTextField)
        
    }
    
    func testSharesSameTaskManagerWithNewTaskVC() {
        let newTaskViewController = presentVC()
        XCTAssertTrue(newTaskViewController.taskManager === sut.dataProvider.taskManager)
    }
    
    func testWhenViewApperedTableViewRealoded() {
        let mockTablView = MockTableView()
        sut.tableView = mockTablView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue((sut.tableView as! MockTableView).isReloaded)
    }
    
    
    func testTappingCellSendsNotification() {
        let task = Task(title: "Foo")
        sut.dataProvider.taskManager?.add(task: task)
        
        expectation(forNotification: NSNotification.Name("DidSelectRownotification"), object: nil) { notification in
            guard let taskFromNotification = notification.userInfo?["task"] as? Task else {
                return false
            }
            return task == taskFromNotification
        }
        let tableView = sut.tableView
        tableView?.delegate?.tableView?(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
        waitForExpectations(timeout: 1)
    }
    
    func testSelectedCellNotificationPushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)
        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        let task1 = Task(title: "Foo")
        let task2 = Task(title: "Bar")
        sut.dataProvider.taskManager?.add(task: task1)
        sut.dataProvider.taskManager?.add(task: task2)
        
        NotificationCenter.default.post(name: NSNotification.Name("DidSelectRownotification"), object: self, userInfo: ["task" : task2])
        
        guard let detailViewContoller = mockNavigationController.pushedViewController as? DetailViewController else {
            XCTFail()
            return
        }
        
        detailViewContoller.loadViewIfNeeded()
        XCTAssertNotNil(detailViewContoller.titleLabel)
        XCTAssertTrue(detailViewContoller.task == task2)
    }
    
}
 
extension TaskListViewControllerTests {
    
    class MockTableView: UITableView {
        var isReloaded = false
        override func reloadData() {
            isReloaded = true
        }
    }
    
}

extension TaskListViewControllerTests {
    
    class MockNavigationController: UINavigationController {
        var pushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            pushedViewController = viewController
            super.pushViewController(viewController, animated: animated)
        }
        
    }
    
}
