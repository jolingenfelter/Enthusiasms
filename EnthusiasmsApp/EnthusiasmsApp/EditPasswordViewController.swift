//
//  EditPasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class EditPasswordViewController: CreatePasswordViewController {
    
    let indentedTextField = IndentedTextField(placeHolder: "Current Password", isSecureEntry: true, tag: 3)
    lazy var passwordTextField: UITextField = {
        
        let textField = self.indentedTextField.textField
        textField.delegate = self
        return textField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "Edit Password"
        
        self.view.addSubview(passwordTextField)
        
        // Button setup
        self.getStartedButton.setTitle("Save Changes", for: .normal)
        
        // Navigation bar
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        self.navigationItem.leftBarButtonItem = cancelButton
        
    }

    
    func passwordTextFieldConstraints() {
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            passwordTextField.heightAnchor.constraint(equalTo: createPasswordTextField.heightAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: createPasswordTextField.widthAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: createPasswordTextField.topAnchor, constant: -25)
            ])
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        passwordTextFieldConstraints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func getStartedButtonPressed() {
        
        if passwordTextField.text == "" || createPasswordTextField.text == "" || confirmPasswordTextField.text == "" {
            presentAlert(title: "Required Fields", message: "Please enter and confirm a new password")
        } else if passwordTextField.text?.hash == UserDefaults.standard.value(forKey: "password") as? Int && self.createPasswordTextField.text == self.confirmPasswordTextField.text {
            
            let hashedPassword = createPasswordTextField.text?.hash
            UserDefaults.standard.setValue(hashedPassword, forKey: "password")
            UserDefaults.standard.synchronize()
            self.dismiss(animated: true, completion: nil)
            
        } else if passwordTextField.text?.hash == UserDefaults.standard.value(forKey: "password") as? Int && self.createPasswordTextField.text != self.confirmPasswordTextField.text {
            
            passwordTextField.text = nil
            createPasswordTextField.text = nil
            confirmPasswordTextField.text = nil
            presentAlert(title: "Incorrect password confirmation", message: "Your passwords do not match")
            
        } else if passwordTextField.text?.hash != UserDefaults.standard.value(forKey: "password") as? Int {
            
            createPasswordTextField.text = nil
            confirmPasswordTextField.text = nil
            passwordTextField.text = nil
            presentAlert(title: "Incorrect password", message: "Incorrect password entry")
            
        }
    }
    
    func cancelPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark: UITextFieldDelegate
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 3 {
            
            if let nextTextField = textField.superview?.viewWithTag(1) {
                nextTextField.becomeFirstResponder()
            }
            
        } else if textField.tag == 1 {
            
            
            if let nextTextField = textField.superview?.viewWithTag(2) {
                nextTextField.becomeFirstResponder()
            }
            
        } else {
            
            textField.resignFirstResponder()
            getStartedButtonPressed()
            
        }
        
        
        return true
    }

}
