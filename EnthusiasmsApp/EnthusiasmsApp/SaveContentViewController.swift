//
//  SaveContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

protocol saveContentViewControllerDelegate {
    func saveContent(withTitle title: String, andURLString: String)
}

class SaveContentViewController: UIViewController {

    var student: Student?
    var content: Content?
    
    var delegate: saveContentViewControllerDelegate!
    
    let indentedTextField = IndentedTextField(placeHolder: nil, isSecureEntry: false, tag: nil)
    
    lazy var contentTitleTextField: UITextField = {
        
        let textField = self.indentedTextField.textField
        textField.delegate = self
        return textField
        
    }()
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Content Title:"
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        return label
        
    }()
    
    lazy var saveContentButton: UIButton = {
        
        let button = UIButton()
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        button.setTitle("Save Content", for: .normal)
        button.addTarget(self, action: #selector(saveContentPressed), for: .touchUpInside)
        self.view.addSubview(button)
        
        return button
        
    }()
    
    init(student: Student?) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(content: Content?) {
        self.init(student: nil)
        self.content = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        navBarSetup()
        
        view.addSubview(contentTitleTextField)
        
    }
    
    func navBarSetup() {
    
        let navBarRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let navBar = UINavigationBar(frame: navBarRect)
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelWasPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelBarButton
        navBar.items = [navItem]
        
        view.addSubview(navBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        labelConstraints()
        textFieldConstraints()
        buttonConstraints()
        
    }
    
    func labelConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentTitleTextField.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
            ])
    }
    
    func textFieldConstraints() {
        
        contentTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentTitleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            contentTitleTextField.heightAnchor.constraint(equalToConstant: 40),
            contentTitleTextField.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    func buttonConstraints() {
        
        saveContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveContentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveContentButton.topAnchor.constraint(equalTo: contentTitleTextField.bottomAnchor, constant: 200),
            saveContentButton.heightAnchor.constraint(equalToConstant: 50),
            saveContentButton.widthAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    @objc func cancelWasPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveContentPressed() {
            
            self.dismiss(animated: true, completion: nil)
            
        
    }
    
}

// MARK: UITextFieldDelegate

extension SaveContentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveContentPressed()
        
        return true
    }
    
}
