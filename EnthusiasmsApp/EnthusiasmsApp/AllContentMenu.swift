//
//  AllContentMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/31/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class AllContentMenu: UIViewController {
    
    lazy var viewContentButton: UIButton = {
        let button = UIButton()
        button.setTitle("View", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var addToStudentButton:  UIButton = {
        let button = UIButton()
        button.setTitle("Add to student", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var changeTitleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change title", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Content", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // Separators
        let separator1 = UIView()
        separator1.backgroundColor = UIColor.lightGray
        view.addSubview(separator1)
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor.lightGray
        view.addSubview(separator2)
        
        let separator3 = UIView()
        separator3.backgroundColor = UIColor.lightGray
        view.addSubview(separator3)
        
        let buttonHeight: CGFloat = 50

        
        // ViewContentButton
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContentButton.bottomAnchor.constraint(equalTo: separator1.topAnchor),
            viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        
        // Separator 1
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            separator1.bottomAnchor.constraint(equalTo: addToStudentButton.topAnchor)
            ])
        
        
        // AddToStudentButton
        addToStudentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToStudentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addToStudentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addToStudentButton.bottomAnchor.constraint(equalTo: separator2.topAnchor),
            addToStudentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator2
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ChangeTitleButton
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeTitleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            changeTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeTitleButton.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            changeTitleButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator3
        separator3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator3.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator3.heightAnchor.constraint(equalToConstant: 1),
            separator3.topAnchor.constraint(equalTo: changeTitleButton.bottomAnchor)
            ])
        
        // DeleteButton
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            deleteButton.topAnchor.constraint(equalTo: separator3.bottomAnchor)
            ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
