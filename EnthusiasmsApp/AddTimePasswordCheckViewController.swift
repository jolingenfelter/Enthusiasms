//
//  AddTimePasswordCheckViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimePasswordCheckViewController: EnterPasswordViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
