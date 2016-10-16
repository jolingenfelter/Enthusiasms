//
//  EditNameViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/15/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class EditNameViewController: UIViewController {
    
    var student: Student?
    let dataController = DataController.sharedInstance
    
    var navItem = UINavigationItem()
    var nameLabel = UILabel()
    var nameTextField = UITextField()
    var saveChangesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // Label setup
        nameLabel.text = "name:"
        
        view.addSubview(nameLabel)
        
        // TextField setup
        nameTextField.text = student?.name
        nameTextField.layer.cornerRadius = 5.0
        nameTextField.layer.masksToBounds = true
        nameTextField.backgroundColor = UIColor.white
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        view.addSubview(nameTextField)
        
        // Button setup
        saveChangesButton.layer.cornerRadius = 5.0
        saveChangesButton.layer.masksToBounds = true
        saveChangesButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        saveChangesButton.setTitle("Save Changes", for: .normal)
        saveChangesButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        view.addSubview(saveChangesButton)
        
        // NavBar
        let navBarRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let navBar = UINavigationBar(frame: navBarRect)
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelWasPressed))
        navItem.title = "Edit Student Name"
        navItem.leftBarButtonItem = cancelBarButton
        navBar.items = [navItem]
        
        view.addSubview(navBar)

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        labelConstraints()
        textFieldConstraints()
        buttonConstraints()
    }
    
    func labelConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor)
        let verticalConstraint = nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func textFieldConstraints() {
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        let heightConstraint = nameTextField.heightAnchor.constraint(equalToConstant: 40)
        let widthConstraint = nameTextField.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
    
    func buttonConstraints() {
        
        saveChangesButton.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = saveChangesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = saveChangesButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 80)
        let heightConstraint = saveChangesButton.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = saveChangesButton.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
    
    func saveChanges() {
        
        if nameTextField.text == "" {
            noNameAlert()
        } else {
            student?.name = nameTextField.text
            dataController.saveContext()
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NameUpdate"), object: nil)
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

}
