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

    let childButton = UIButton()
    let caretakerButton = UIButton()
    let enthusiasmsLabel = UILabel()
    var fetchedStudents: [Student] = []
    
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
        caretakerButton.setTitle("Caretaker", for: .normal)
        caretakerButton.titleLabel?.textColor = UIColor.white
        caretakerButton.titleLabel?.font = caretakerButton.titleLabel?.font.withSize(50)
        caretakerButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        caretakerButton.layer.cornerRadius = 5
        caretakerButton.layer.masksToBounds = true
        caretakerButton.addTarget(self, action: #selector(caretakerPressed), for: .touchUpInside)
        self.view.addSubview(caretakerButton)
        
        childButton.setTitle("Child", for: .normal)
        childButton.titleLabel?.textColor = UIColor.white
        childButton.titleLabel?.font = childButton.titleLabel?.font.withSize(50)
        childButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        childButton.layer.cornerRadius = 5
        childButton.layer.masksToBounds = true
        childButton.addTarget(self, action: #selector(childPressed), for: .touchUpInside)
        self.view.addSubview(childButton)
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
        
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = Student.fetchRequest()
        
        do {
            fetchedStudents = try managedObjectContext.fetch(request) as! [Student]
        } catch let error {
            print(error)
        }
    }
    
    func labelConstraints() {
        
        enthusiasmsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = enthusiasmsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = enthusiasmsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
    
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func buttonConstraints() {

        caretakerButton.translatesAutoresizingMaskIntoConstraints = false
        
        let teacherButtonHorizontalConstraint = caretakerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let teacherButtonVerticalConstraint = caretakerButton.topAnchor.constraint(equalTo: enthusiasmsLabel.bottomAnchor, constant: 200)
        let teacherButtonHeight = caretakerButton.heightAnchor.constraint(equalToConstant: 90)
        let teacherButtonWidth = caretakerButton.widthAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([teacherButtonHorizontalConstraint, teacherButtonVerticalConstraint, teacherButtonHeight, teacherButtonWidth])
        
        childButton.translatesAutoresizingMaskIntoConstraints = false
        
        let studentButtonHorizontalConstraint = childButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let studentButtonVerticalConstraint = childButton.topAnchor.constraint(equalTo: caretakerButton.bottomAnchor, constant: 30)
        let studentButtonHeight = childButton.heightAnchor.constraint(equalTo: caretakerButton.heightAnchor)
        let studentButtonWidth = childButton.widthAnchor.constraint(equalTo: caretakerButton.widthAnchor)
        
        NSLayoutConstraint.activate([studentButtonHorizontalConstraint, studentButtonVerticalConstraint, studentButtonHeight, studentButtonWidth])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func caretakerPressed() {
        
        let studentListViewController = StudentListViewController()
        
        self.navigationController?.pushViewController(studentListViewController, animated: true)
    }

    func childPressed() {
        
        if fetchedStudents.count == 0 {
            let alertController = UIAlertController(title: "No Children", message: "Enter as a caretaker to get started", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else {
            studentListPopover.preferredContentSize = CGSize(width: 200, height: 200)
            studentListPopover.modalPresentationStyle = UIModalPresentationStyle.popover
            studentListPopover.popoverPresentationController?.permittedArrowDirections = .left
            let popover = studentListPopover.popoverPresentationController! as UIPopoverPresentationController
            popover.sourceView = self.childButton
            popover.sourceRect = CGRect(x: 300, y: 50, width: 0, height: 0)
            self.navigationController?.present(studentListPopover, animated: true, completion: nil)
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

