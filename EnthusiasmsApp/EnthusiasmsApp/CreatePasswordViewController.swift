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
    
    var password = String()
    
    let getStartedButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        // MARK: View Label Setup
        titleLabel.numberOfLines = 0
        let welcome = "Welcome to Enthusiasms!"
        let createPassword = "Create a password to get started."
        titleLabel.text = welcome + "\n" + createPassword
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = titleLabel.font.withSize(40)
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
        let titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 200)
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 20)
        let titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -20)
        NSLayoutConstraint.activate([titleLabelTopConstraint, titleLabelHeightConstraint, titleLabelLeadingConstraint, titleLabelTrailingConstraint])
        
        // MARK: TextField Setup
        createPasswordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
        
        createPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        let textFieldHeight: CGFloat = 40
        let textFieldWidth: CGFloat = 250
        
        /*
        let textInset = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldHeight))
        createPasswordTextField.leftView = textInset
        confirmPasswordTextField.leftView = textInset
        createPasswordTextField.leftViewMode = UITextFieldViewMode.always
        //confirmPasswordTextField.leftViewMode = UITextFieldViewMode.always
         */
        
        createPasswordTextField.backgroundColor = UIColor.white
        confirmPasswordTextField.backgroundColor = UIColor.white
        
        createPasswordTextField.layer.cornerRadius = 5.0
        createPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.layer.cornerRadius = 5.0
        confirmPasswordTextField.layer.masksToBounds = true
        
        self.view.addSubview(createPasswordTextField)
        self.view.addSubview(confirmPasswordTextField)
        
        createPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        // createPasswordTextField constraints
        let createPasswordHorizontalConstraint = createPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let createPasswordVerticalConstraint = createPasswordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80)
        let createPasswordHeightConstraint = createPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        let createPasswordWidthConstraint = createPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth)
        NSLayoutConstraint.activate([createPasswordHorizontalConstraint,createPasswordVerticalConstraint, createPasswordHeightConstraint, createPasswordWidthConstraint])
        
        // confirmPasswordTextField constraints
        let confirmPasswordHorizontalConstraint = confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let confirmPasswordVerticalConstraint = confirmPasswordTextField.topAnchor.constraint(equalTo: createPasswordTextField.bottomAnchor, constant: 25)
        let confirmPasswordHeightConstraint = confirmPasswordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight)
        let confirmPasswordWidthConstraint = confirmPasswordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth)
        NSLayoutConstraint.activate([confirmPasswordHorizontalConstraint, confirmPasswordVerticalConstraint, confirmPasswordHeightConstraint, confirmPasswordWidthConstraint])
        
        // MARK: Button Setup
        getStartedButton.layer.cornerRadius = 5.0
        getStartedButton.layer.masksToBounds = true
        getStartedButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        getStartedButton.setTitle("Get Started!", for: .normal)
        getStartedButton.addTarget(self, action: #selector(CreatePasswordViewController.getStartedButtonPressed), for: .touchUpInside)
        
        view.addSubview(getStartedButton)
        
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        
        let getStartedButtonHorizontalConstraint = getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let getStartedButtonVerticalConstraint = getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150)
        let getStartedButtonHeightConstraint = getStartedButton.heightAnchor.constraint(equalToConstant: 60)
        let getStartedButtonWidthConstraint = getStartedButton.widthAnchor.constraint(equalToConstant: 400)
        NSLayoutConstraint.activate([getStartedButtonHorizontalConstraint, getStartedButtonVerticalConstraint, getStartedButtonHeightConstraint, getStartedButtonWidthConstraint])

    }
    
    func getStartedButtonPressed() {
        if createPasswordTextField.text == "" || confirmPasswordTextField.text == "" {
            presentAlert(title: "Required", message: "Input and confirm password to continue")
        } else if createPasswordTextField.text != confirmPasswordTextField.text {
            presentAlert(title: "Incorrect password", message: "Passwords do not match")
        } else if createPasswordTextField.text == confirmPasswordTextField.text {
            
            password = createPasswordTextField.text!
            let hashedpassword = password.hash
            
            let preferences = UserDefaults.standard
            preferences.setValue(hashedpassword, forKey: "password")
            
            let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.present(homeViewController, animated: true, completion: nil)
            
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
