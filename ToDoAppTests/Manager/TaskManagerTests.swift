//
//  TaskManagerTests.swift
//  ToDoAppTests
//
//  Created by Сергей Насыбуллин on 25.05.2023.
//

import XCTest
@testable import ToDoApp

final class TaskManagerTests: XCTestCase {

    var sut: TaskManager!
    
    override func setUpWithError() throws {
        sut = TaskManager()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testInintTaskManagerWihtZeroTasks() {
        XCTAssertEqual(sut.tasksCount, 0)
    }
    
    func testInintTaskManagerWihtZeroDoneTasks() {
        XCTAssertEqual(sut.doneTasksCount, 0)
    }

    func testAddTaskIncrementTaskCount() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        XCTAssertEqual(sut.tasksCount, 1)
    }
    
    func testTaskAtIndexIsAddedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        let returnTask = sut.task(at: 0)
        
        XCTAssertEqual(task.title, returnTask.title)
    }
    
    func testChekTaskAtIndexChangesCount() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.chekTask(at: 0)
        
        XCTAssertEqual(sut.tasksCount, 0)
        XCTAssertEqual(sut.doneTasksCount, 1)
    }
    
    func testChekedTaskRemoveFromTasks() {
        let firstTask = Task(title: "Foo")
        let secondTask = Task(title: "Bar")
        
        sut.add(task: firstTask)
        sut.add(task: secondTask)
        
        sut.chekTask(at: 0)
        
        XCTAssertEqual(sut.task(at: 0), secondTask)
    }
    
    func testDoneTaskAddReternsChekedTask() {
        let task = Task(title: "Foo")
        sut.add(task: task)
        
        sut.chekTask(at: 0)
        let returnedTask = sut.doneTasks(at: 0)
        
        XCTAssertEqual(returnedTask , task)
    }
    
    
    func testRemoveAllResultsCountBeZero() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Bar"))
        sut.chekTask(at: 0)
        
        sut.removeAll()
        
        XCTAssertTrue(sut.tasksCount == 0)
        XCTAssertTrue(sut.doneTasksCount == 0)
    }
    
    func testAddingSameObjectDoesNotIncrimentCount() {
        sut.add(task: Task(title: "Foo"))
        sut.add(task: Task(title: "Foo"))
        
        XCTAssertTrue(sut.tasksCount == 1)
    }
    
    
}
