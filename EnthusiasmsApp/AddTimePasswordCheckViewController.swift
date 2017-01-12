//
//  AddTimePasswordCheckViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimePasswordCheckViewController: EnterPasswordViewController {
    
    let navigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        
        // NavBar Setup
        view.addSubview(navigationBar)
        let navigationItem = UINavigationItem(title: "Enter Password")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        navigationItem.leftBarButtonItem = cancelButton
        navigationBar.items = [navigationItem]
        
        // Title Label
        titleLabel.isHidden = true
        
        // Button Setup
        self.getStartedButton.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        self.getStartedButton.setTitle("Enter", for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationBarLeadingConstraint = navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let navigationBarTrailingConstraint = navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let navigationBarTopConstraint = navigationBar.topAnchor.constraint(equalTo: view.topAnchor)
        let navigationBarHeightConstraint = navigationBar.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([navigationBarLeadingConstraint, navigationBarTrailingConstraint, navigationBarTopConstraint, navigationBarHeightConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setButtonConstraints() {
        self.getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonHorizontalConstraint = self.getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let buttonVerticalConstraint = self.getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        let buttonHeightConstraint = self.getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        let buttonWidthConstraint = self.getStartedButton.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([buttonHorizontalConstraint, buttonVerticalConstraint, buttonHeightConstraint, buttonWidthConstraint])
    }
    
    override func getStartedButtonPressed() {
        if self.createPasswordTextField.text?.hash == UserDefaults.standard.value(forKey: "password") as? Int {
            let addTimeViewController = AddTimeViewController()
            addTimeViewController.modalPresentationStyle = .formSheet
            self.createPasswordTextField.text = nil
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
            
        } else {
            presentAlert(title: "Incorrect Password", message: "The password you have entered is incorrect")
        }
    }
    
    func cancelPressed() {
        NotificationCenter.default.post(name: NSNotification.Name("cancelTimeUpdate"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }

}
