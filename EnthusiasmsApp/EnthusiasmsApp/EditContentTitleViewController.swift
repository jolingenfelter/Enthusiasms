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
        
        contentTitleTextField.text = content?.title

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func saveContentPressed() {
        content?.title = contentTitleTextField.text
        let dataController = DataController.sharedInstance
        dataController.saveContext()
        self.dismiss(animated: true, completion: nil)
    }

}
