//
//  TaskManager.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 25.05.2023.
//


import Foundation
import UIKit

class TaskManager {
    
    private var tasks: [Task] = []
    private var doneTasks: [Task] = []
    
    var tasksCount: Int {
        return tasks.count
    }
    
    var doneTasksCount: Int {
        return doneTasks.count
    }
    
    var taskURL : URL {
        let fileURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentURL = fileURLs.first else {
            fatalError()
        }
        if #available(iOS 16.0, *) {
            return documentURL.appending(path: "tasks.plist")
        } else {
            return documentURL.appendingPathComponent("tasks.plist")
        }
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        
        if let data = try? Data(contentsOf: taskURL) {
            let dictionary = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [[String:Any]]
            for dict in dictionary {
                if let task = Task(dict: dict) {
                    tasks.append(task)
                }
            }
        }
    }
    
    deinit {
        save()
    }
    
    @objc func save() {
        let tasksDict = self.tasks.map { $0.dict }
        guard tasksDict.count > 0 else {
            try? FileManager.default.removeItem(at: taskURL)
            return
        }
        
        let plistData = try? PropertyListSerialization.data(fromPropertyList: tasksDict, format: .xml, options: PropertyListSerialization.WriteOptions(0))
        
        try? plistData?.write(to: taskURL  )
    }
    
    
    func add(task: Task) {
        if !tasks.contains(task) {
            tasks.append(task)
        }
    }
    
    func task(at index: Int) -> Task {
        return tasks[index]
    }
    
    func chekTask(at index: Int) {
        var task = tasks.remove(at: index)
        task.isDone.toggle()
        doneTasks.append(task)
    }
    
    func unchekTask(at index: Int) {
        var task = doneTasks.remove(at: index)
        task.isDone.toggle()
        tasks.append(task)
    }
    
    
    func doneTasks(at index: Int) -> Task {
        return doneTasks[index]
    }
    
    func removeAll() {
        tasks.removeAll()
        doneTasks.removeAll()
    }
    
}
