//
//  EditPasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class EditPasswordViewController: CreatePasswordViewController {
    
    let passwordTextField = UITextField()
    let navigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = "Edit Password"
        
        // TextField setup
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.layer.masksToBounds = true
        self.view.addSubview(passwordTextField)
        
        passwordTextField.placeholder = "Current password"
        createPasswordTextField.placeholder = "New password"
        confirmPasswordTextField.placeholder = "Confirm new password"
        
        let textFieldHeight: Int = 40
        let textInset = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldHeight))
        passwordTextField.leftView = textInset
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        // Button setup
        self.getStartedButton.setTitle("Save Changes", for: .normal)
        
        // Navigation bar
        self.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        self.view.addSubview(self.navigationBar)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelButton
        self.navigationBar.items = [navItem]
        
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navigationBar.frame = CGRect(x: 0, y: 0, width: size.width, height: 60)
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

}
