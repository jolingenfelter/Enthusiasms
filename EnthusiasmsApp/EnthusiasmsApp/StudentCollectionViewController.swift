//
//  StudentCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class StudentCollectionViewController: TeacherCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = studentName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func navigationBarSetup() {
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(StudentCollectionViewController.homePressed))
        self.navigationItem.rightBarButtonItem = homeButton
    }

}
