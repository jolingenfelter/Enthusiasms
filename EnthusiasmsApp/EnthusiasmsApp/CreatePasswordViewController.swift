//
//  CreatePasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/4/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        let welcome = "Welcome to Enthusiasms!"
        let createPassword = "Create a password to get started."
        label.text = welcome + "\n" + createPassword
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = label.font.withSize(40)
        self.view.addSubview(label)
        
        return label
        
    }()
    
    let indentedTextField1 = IndentedTextField(placeHolder: "Password", isSecureEntry: true, tag: 1)
    let indentedTextField2 = IndentedTextField(placeHolder: "Confirm password", isSecureEntry: true, tag: 2)
    
    lazy var createPasswordTextField: UITextField = {
        
        let textField = self.indentedTextField1.textField
        textField.delegate = self
        self.view.addSubview(textField)
        return textField
        
    }()
    
    lazy var confirmPasswordTextField: UITextField = {
        
        let textField = self.indentedTextField2.textField
        textField.delegate = self
        self.view.addSubview(textField)
        return textField
        
    }()
    
    lazy var getStartedButton: UIButton = {
        
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        button.setTitle("Get Started!", for: .normal)
        button.addTarget(self, action: #selector(CreatePasswordViewController.getStartedButtonPressed), for: .touchUpInside)
        self.view.addSubview(button)
        
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        setLabelConstraints()
        setTextFieldConstraints()
        setButtonConstraints()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: View Layout

    func setLabelConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            titleLabel.heightAnchor.constraint(equalToConstant: 200),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }
    
    func setTextFieldConstraints() {

        let textFieldHeight: CGFloat = 40
        let textFieldWidth: CGFloat = 250
        
        
        // createPasswordTextField constraints
        createPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            createPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            createPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            createPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth)
            ])
        
        // confirmPasswordTextField constraints
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTextField.topAnchor.constraint(equalTo: createPasswordTextField.bottomAnchor, constant: 25),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth)
            ])
    }
    
    func setButtonConstraints() {
        
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            getStartedButton.heightAnchor.constraint(equalToConstant: 60),
            getStartedButton.widthAnchor.constraint(equalToConstant: 400)])
    }
    
    @objc func getStartedButtonPressed() {
        
        if createPasswordTextField.text == "" || confirmPasswordTextField.text == "" {
            
            presentAlert(title: "Required", message: "Input and confirm password to continue")
            
        } else if createPasswordTextField.text != confirmPasswordTextField.text {
            
            presentAlert(title: "Incorrect password", message: "Passwords do not match")
            
        } else if createPasswordTextField.text == confirmPasswordTextField.text {
            
            let hashedpassword = createPasswordTextField.text?.hash
            
            let preferences = UserDefaults.standard
            preferences.setValue(hashedpassword, forKey: "password")
            
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            self.present(navigationController, animated: true, completion: nil)
            
        }
    }
    
    // MARK: Helper Methods
    
    func presentAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - UITextFieldDelegate

extension CreatePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
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
