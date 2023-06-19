//
//  ViewController.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 24.05.2023.
//

import UIKit

class TaskListViewContoller: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var dataProvider: DataProvider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let taskManager = TaskManager()
        dataProvider.taskManager = taskManager
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetail(withNotification:)), name: NSNotification.Name(rawValue: "DidSelectRownotification"), object: nil)
    }

    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController {
            viewController.taskManager = self.dataProvider.taskManager
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
 
    @objc func showDetail(withNotification notification: Notification ) {
        guard
            let userInfo = notification.userInfo,
            let task = userInfo["task"] as? Task,
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            fatalError()
        }
        detailViewController.task = task
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

