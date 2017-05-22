//
//  TeacherSettingsMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/22/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class TeacherSettingsMenu: UIViewController {
    
    lazy var editNameButton : UIButton = {
        
        let button = UIButton()
        button.setTitle("Edit Student Name", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        
        return button
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        editNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editNameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editNameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            editNameButton.heightAnchor.constraint(equalToConstant: 50)
            ])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
