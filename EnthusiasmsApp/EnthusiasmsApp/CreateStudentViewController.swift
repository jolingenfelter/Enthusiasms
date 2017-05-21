//
//  CreateStudentPopoverViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/18/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class CreateStudentViewController: EditNameViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveChangesButton.setTitle("Add Child", for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func saveChanges() {
        if nameTextField.text == "" {
            noNameAlert()
        } else {
            let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: dataController.managedObjectContext) as! Student
            student.name = nameTextField.text
            dataController.saveContext()
            dismiss(animated: true, completion: nil)
        }

    }

}
 
