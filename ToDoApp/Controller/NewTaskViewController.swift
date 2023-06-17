//
//  NewTaskViewController.swift
//  ToDoApp
//
//  Created by Сергей Насыбуллин on 29.05.2023.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {

    var taskManager: TaskManager!
    
    var geocoder = CLGeocoder()
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var adressTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    
    @IBAction func save() {
        let titleString = titleTextField.text!
        let locationString = locationTextField.text!
        let date = dateFormatter.date(from: dateTextField.text!)
        let descriptionString = descriptionTextField.text
        let addressString = adressTextField.text
        
        geocoder.geocodeAddressString(addressString!) { [unowned self] (placemarks, error) in
            let placemark = placemarks?.first
            let coorditante = placemark?.location?.coordinate
            let location = Location(name: locationString, coordinate: coorditante)
            let task = Task(title: titleString, description: descriptionString, date: date, location: location)
            self.taskManager.add(task: task)
        }
    }
    
}

