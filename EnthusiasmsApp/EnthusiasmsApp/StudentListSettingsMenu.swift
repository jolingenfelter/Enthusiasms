//
//  StudentListSettingsMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/22/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class StudentListSettingsMenu: UIViewController {
    
    lazy var editPasswordButton : UIButton = {
        let button = UIButton()
        button.setTitle("Edit Password", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        editPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editPasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            editPasswordButton.heightAnchor.constraint(equalToConstant: 50),
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
