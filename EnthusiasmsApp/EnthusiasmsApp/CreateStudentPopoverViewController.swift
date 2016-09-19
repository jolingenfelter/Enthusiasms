//
//  CreateStudentPopoverViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/18/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class CreateStudentPopoverViewController: UIViewController {

    @IBOutlet weak var studentNameTextField: UITextField!
    
    let dataController = DataController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func addStudentPressed(_ sender: AnyObject) {
        let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: dataController.managedObjectContext) as! Student
        student.name = studentNameTextField.text
        dataController.saveContext()
        dismiss(animated: true, completion: nil)
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
