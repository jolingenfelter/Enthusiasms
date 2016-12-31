//
//  EditContentTitleViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/21/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class EditContentTitleViewController: SaveContentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        contentTitleTextField.text = content?.title
        saveContentButton.setTitle("Save Changes", for: .normal)
        saveContentButton.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func saveContentPressed() {
        if contentTitleTextField.text == "" {
            let alert = UIAlertController(title: "Required Field", message: "Please enter a title for this content", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        } else {
            content?.title = contentTitleTextField.text
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentTitleUpdate"), object: nil)
            let dataController = DataController.sharedInstance
            dataController.saveContext()
            self.dismiss(animated: true, completion: nil)
        }
    }

}
