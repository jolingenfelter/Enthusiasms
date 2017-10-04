//
//  AddContentFromLibraryMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/23/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class AddContentFromLibraryMenu: UIViewController {
    
    let student: Student
    
    lazy var addContentButton: UIButton = {
        let button = UIButton()
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
    
    lazy var viewContentButton: UIButton = {
        let button = UIButton()
        button.setTitle("View", for: .normal)
        button.setTitleColor(.black, for: .normal)
        self.view.addSubview(button)
        return button
    }()

    
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonHeight: CGFloat = 75
        
        // AddContentButton
        addContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addContentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addContentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addContentButton.topAnchor.constraint(equalTo: view.topAnchor),
            addContentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.topAnchor.constraint(equalTo: addContentButton.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ViewContentButton
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContentButton.topAnchor.constraint(equalTo: separator.bottomAnchor),
            viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
