//
//  EnterPasswordViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 10/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class EnterPasswordViewController: CreatePasswordViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "Enter Password"
        self.confirmPasswordTextField.isHidden = true
    }
    
    override func getStartedButtonPressed() {
        if self.createPasswordTextField.text?.hash == UserDefaults.standard.value(forKey: "password") as? Int {
            let homeViewController = HomeViewController()
            let navigationController = UINavigationController(rootViewController: homeViewController)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            presentAlert(title: "Incorrect Password", message: "The password you have entered is incorrect")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
