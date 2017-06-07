//
//  EnterPasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class EnterPasswordViewController: CreatePasswordViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelRequest"), object: nil)
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.titleLabel.text = "Enter Password"
        self.confirmPasswordTextField.placeholder = "Password"
        self.createPasswordTextField.isHidden = true
        
    }
    
    override func getStartedButtonPressed() {
        
        if self.confirmPasswordTextField.text?.hash == UserDefaults.standard.value(forKey: "password") as? Int {
            
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            
            self.confirmPasswordTextField.text = nil
            self.present(navigationController, animated: true, completion: nil)
            
        } else {
            
            presentAlert(title: "Incorrect Password", message: "The password you have entered is incorrect")
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
