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
    
    var nameLabel = UILabel()
    var saveChangesButton = UIButton()
    
    var indentedTextField = IndentedTextField(placeHolder: nil, isSecureEntry: false, tag: nil)
    lazy var nameTextField: UITextField = {
        
        let textField = self.indentedTextField.textField
        textField.delegate = self
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.text = self.student?.name
        return textField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // Label setup
        nameLabel.text = "name:"

        
        // Button setup
        saveChangesButton.layer.cornerRadius = 5.0
        saveChangesButton.layer.masksToBounds = true
        saveChangesButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        saveChangesButton.setTitle("Save Changes", for: .normal)
        saveChangesButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        
        view.addSubview(saveChangesButton)
        
        // NavBar Setup
        let navBarRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let navBar = UINavigationBar(frame: navBarRect)
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelWasPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelBarButton
        navBar.items = [navItem]
        
        view.addSubview(navBar)

        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        labelConstraints()
        textFieldConstraints()
        buttonConstraints()
    }
    
    func labelConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150)
            ])
    }
    
    func textFieldConstraints() {
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.heightAnchor.constraint(equalToConstant: 40),
            nameTextField.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    func buttonConstraints() {
        
        saveChangesButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveChangesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveChangesButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 80),
            saveChangesButton.heightAnchor.constraint(equalToConstant: 50),
            saveChangesButton.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    func saveChanges() {
        
        if nameTextField.text == "" {
            noNameAlert()
        } else {
            student?.name = nameTextField.text
            DataController.sharedInstance.saveContext()
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

// MARK: UITextFieldDelegate

extension EditNameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveChanges()
        
        return true
    }
    
}
