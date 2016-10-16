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
        
        navItem.title = "Add Student"
        saveChangesButton.setTitle("Add Student", for: .normal)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
