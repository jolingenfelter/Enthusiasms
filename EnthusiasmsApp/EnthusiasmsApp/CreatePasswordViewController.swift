//
//  CreatePasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/4/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class CreatePasswordViewController: UIViewController, UITextFieldDelegate {
    
    let titleLabel = UILabel()
    
    let createPasswordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    
    let getStartedButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        // Label Setup
        titleLabel.numberOfLines = 0
        let welcome = "Welcome to Enthusiasms!"
        let createPassword = "Create a password to get started."
        titleLabel.text = welcome + "\n" + createPassword
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = titleLabel.font.withSize(40)
        view.addSubview(titleLabel)
        
        // TextFields Setup
        createPasswordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm password"
        
        createPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        createPasswordTextField.backgroundColor = UIColor.white
        confirmPasswordTextField.backgroundColor = UIColor.white
        
        createPasswordTextField.layer.cornerRadius = 5.0
        createPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.layer.cornerRadius = 5.0
        confirmPasswordTextField.layer.masksToBounds = true
        
        self.view.addSubview(createPasswordTextField)
        self.view.addSubview(confirmPasswordTextField)
        
        let textFieldHeight: CGFloat = 40
        
        let textInset1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldHeight))
        createPasswordTextField.leftView = textInset1
        createPasswordTextField.leftViewMode = UITextFieldViewMode.always
        
        let textInset2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldHeight))
        confirmPasswordTextField.leftView = textInset2
        confirmPasswordTextField.leftViewMode = UITextFieldViewMode.always

        
        // Button Setup
        getStartedButton.layer.cornerRadius = 5.0
        getStartedButton.layer.masksToBounds = true
        getStartedButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        getStartedButton.setTitle("Get Started!", for: .normal)
        getStartedButton.addTarget(self, action: #selector(CreatePasswordViewController.getStartedButtonPressed), for: .touchUpInside)
        
        view.addSubview(getStartedButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        
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
        
        createPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        // createPasswordTextField constraints
        
        NSLayoutConstraint.activate([
            createPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            createPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            createPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth)
            ])
        
        // confirmPasswordTextField constraints

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
    
    func getStartedButtonPressed() {
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
