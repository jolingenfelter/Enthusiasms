//
//  StudentListPopover.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class StudentListPopover: StudentListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.fetchedResultsController.object(at: indexPath)
        let studentCollectionView = StudentCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        studentCollectionView.studentName = student.name!
        let navController = UINavigationController(rootViewController: studentCollectionView)
        self.present(navController, animated: true, completion: nil)
    }

}
