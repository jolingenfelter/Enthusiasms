//
//  TeacherAddContentMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/22/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class TeacherAddContentMenu: UIViewController {
    
    lazy var contentFromWebButton: UIButton = {
        let button = UIButton()
        button.setTitle("Web Content", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.view.addSubview(view)
        return view
    }()
    
    lazy var contentFromLibraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Content from library", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonHeight: CGFloat = 75
        
        // ContentFromWebButton Constraints
        contentFromWebButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentFromWebButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentFromWebButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentFromWebButton.bottomAnchor.constraint(equalTo: separator.topAnchor),
            contentFromWebButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator Constraints
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
            ])
        
    
        // ContentFromLibraryButton Constraints
        contentFromLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentFromLibraryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentFromLibraryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentFromLibraryButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            contentFromLibraryButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
