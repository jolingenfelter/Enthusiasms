//
//  TeacherCellMenu.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/22/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class TeacherCellMenu: UIViewController {
    
    let studentName: String
    
    lazy var removeButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Remove from \(self.studentName)", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.black, for: .normal)
        self.view.addSubview(button)
        
        return button
        
    }()
    
    lazy var separator1: UIView = {
        
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
    
    lazy var separator2: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.view.addSubview(view)
        
        return view
        
    }()
    
    lazy var changeTitleButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Change Title", for: .normal)
        button.setTitleColor(.black, for: .normal)
        self.view.addSubview(button)
        
        return button
        
    }()
    
    
    init(name: String) {
        self.studentName = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: View Layout
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let buttonHeight: CGFloat = 60
        
        // RemoveButton Constraints
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            removeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            removeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            removeButton.bottomAnchor.constraint(equalTo: separator1.topAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator1 Constraints
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator1.bottomAnchor.constraint(equalTo: viewContentButton.topAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ViewContentButton Constraints
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewContentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewContentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        
        // Separator 2 Constraints
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator2.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator2.topAnchor.constraint(equalTo: viewContentButton.bottomAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ChangeTitleButton Constraints
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeTitleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            changeTitleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeTitleButton.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            changeTitleButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
