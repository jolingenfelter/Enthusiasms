//
//  StudentListPopover.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class StudentListPopover: StudentListViewController {
    
    var selectedStudent: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = self.fetchedResultsController.object(at: indexPath)
        selectedStudent = student
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StudentSelected"), object: nil)
        
        self.dismiss(animated: false, completion: nil)
    }

}
