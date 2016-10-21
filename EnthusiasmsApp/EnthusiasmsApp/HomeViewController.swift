//
//  ViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    let studentButton = UIButton()
    let teacherButton = UIButton()
    let enthusiasmsLabel = UILabel()
    
    let studentListPopover = StudentListPopover()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(studentSelected), name: NSNotification.Name(rawValue: "StudentSelected"), object: nil)
        
        // Label Setup
        enthusiasmsLabel.text = "Enthusiasms"
        enthusiasmsLabel.adjustsFontSizeToFitWidth = true
        enthusiasmsLabel.textColor = UIColor.white
        enthusiasmsLabel.font = enthusiasmsLabel.font.withSize(130)
        self.view.addSubview(enthusiasmsLabel)
        
        // Button Setup
        teacherButton.setTitle("Teacher", for: .normal)
        teacherButton.titleLabel?.textColor = UIColor.white
        teacherButton.titleLabel?.font = teacherButton.titleLabel?.font.withSize(50)
        teacherButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        teacherButton.layer.cornerRadius = 5
        teacherButton.layer.masksToBounds = true
        teacherButton.addTarget(self, action: #selector(teacherPressed), for: .touchUpInside)
        self.view.addSubview(teacherButton)
        
        studentButton.setTitle("Student", for: .normal)
        studentButton.titleLabel?.textColor = UIColor.white
        studentButton.titleLabel?.font = studentButton.titleLabel?.font.withSize(50)
        studentButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        studentButton.layer.cornerRadius = 5
        studentButton.layer.masksToBounds = true
        studentButton.addTarget(self, action: #selector(studentPressed), for: .touchUpInside)
        self.view.addSubview(studentButton)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StudentSelected"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        labelConstraints()
        buttonConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func labelConstraints() {
        
        enthusiasmsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = enthusiasmsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = enthusiasmsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
    
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func buttonConstraints() {

        teacherButton.translatesAutoresizingMaskIntoConstraints = false
        
        let teacherButtonHorizontalConstraint = teacherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let teacherButtonVerticalConstraint = teacherButton.topAnchor.constraint(equalTo: enthusiasmsLabel.bottomAnchor, constant: 200)
        let teacherButtonHeight = teacherButton.heightAnchor.constraint(equalToConstant: 90)
        let teacherButtonWidth = teacherButton.widthAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([teacherButtonHorizontalConstraint, teacherButtonVerticalConstraint, teacherButtonHeight, teacherButtonWidth])
        
        studentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let studentButtonHorizontalConstraint = studentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let studentButtonVerticalConstraint = studentButton.topAnchor.constraint(equalTo: teacherButton.bottomAnchor, constant: 30)
        let studentButtonHeight = studentButton.heightAnchor.constraint(equalTo: teacherButton.heightAnchor)
        let studentButtonWidth = studentButton.widthAnchor.constraint(equalTo: teacherButton.widthAnchor)
        
        NSLayoutConstraint.activate([studentButtonHorizontalConstraint, studentButtonVerticalConstraint, studentButtonHeight, studentButtonWidth])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func teacherPressed() {
        
        let studentListViewController = StudentListViewController()
        
        self.navigationController?.pushViewController(studentListViewController, animated: true)
    }

    func studentPressed() {
        
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = Student.fetchRequest()
        
        do {
            let fetchedStudents = try managedObjectContext.fetch(request) as! [Student]
            
            if fetchedStudents.count == 0 {
                let alertController = UIAlertController(title: "No Students", message: "Enter as a teacher to get started", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                studentListPopover.preferredContentSize = CGSize(width: 200, height: 200)
                studentListPopover.modalPresentationStyle = UIModalPresentationStyle.popover
                studentListPopover.popoverPresentationController?.permittedArrowDirections = .left
                let popover = studentListPopover.popoverPresentationController! as UIPopoverPresentationController
                popover.sourceView = self.studentButton
                popover.sourceRect = CGRect(x: 300, y: 50, width: 0, height: 0)
                self.navigationController?.present(studentListPopover, animated: true, completion: nil)
            }
            
        } catch (let error) {
            print(error)
        }
    }
    
    func studentSelected() {
        let timerViewController = SetTimerViewController()
        timerViewController.student = studentListPopover.selectedStudent
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

