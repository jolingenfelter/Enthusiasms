//
//  AddContentToStudentPopoverViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddContentToStudentPopoverViewController: StudentListPopover {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = self.fetchedResultsController.object(at: indexPath)
        selectedStudent = student
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
        
        self.dismiss(animated: true, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
