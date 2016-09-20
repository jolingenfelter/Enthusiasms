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
        

    }
    
    override func viewDidLayoutSubviews() {
        let navBarRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let navBar = UINavigationBar(frame: navBarRect)
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreateStudentPopoverViewController.cancelWasPressed))
        let navItem = UINavigationItem(title: "Add a Student")
        navItem.leftBarButtonItem = cancelBarButton
        navBar.items = [navItem]
        
        view.addSubview(navBar)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addStudentPressed(_ sender: AnyObject) {
        
        if studentNameTextField.text == "" {
            noNameAlert()
        } else {
            let student = NSEntityDescription.insertNewObject(forEntityName: "Student", into: dataController.managedObjectContext) as! Student
            student.name = studentNameTextField.text
            dataController.saveContext()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelWasPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func noNameAlert() {
        let alertVC = UIAlertController(title: "Required Field", message: "Please enter student name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
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
