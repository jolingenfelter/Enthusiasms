//
//  SaveContentViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/11/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class SaveContentViewController: UIViewController {
    
    var saveContentButton = UIButton()
    var contentTitleTextField = UITextField()
    var titleLabel = UILabel()
    var content : Content?
    var student: Student?
    var contentURL: String?
    var contentType: ContentType?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        // NavBar Setup
        let navBarRect = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        let navBar = UINavigationBar(frame: navBarRect)
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelWasPressed))
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = cancelBarButton
        navBar.items = [navItem]
        
        view.addSubview(navBar)
        
        // Label Setup
        titleLabel.text = "Content Title:"
        titleLabel.textColor = UIColor.white
        
        view.addSubview(titleLabel)
        
        // Button Setup
        saveContentButton.layer.cornerRadius = 5.0
        saveContentButton.layer.masksToBounds = true
        saveContentButton.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        saveContentButton.setTitle("Save Content", for: .normal)
        saveContentButton.addTarget(self, action: #selector(saveContentPressed), for: .touchUpInside)
        
        view.addSubview(saveContentButton)
        
        // TextFieldSetup
        contentTitleTextField.layer.cornerRadius = 5.0
        contentTitleTextField.layer.masksToBounds = true
        contentTitleTextField.backgroundColor = UIColor.white
        contentTitleTextField.autocorrectionType = .no
        let textFieldHeight: CGFloat = 40
        let textInset1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textFieldHeight))
        contentTitleTextField.leftView = textInset1
        contentTitleTextField.leftViewMode = UITextFieldViewMode.always
        
        view.addSubview(contentTitleTextField)

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
        
        let horizontalConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentTitleTextField.leadingAnchor)
        let verticalConstraint = titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
    }
    
    func textFieldConstraints() {
        
        contentTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = contentTitleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = contentTitleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        let heightConstraint = contentTitleTextField.heightAnchor.constraint(equalToConstant: 40)
        let widthConstraint = contentTitleTextField.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
    
    func buttonConstraints() {
        
        saveContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = saveContentButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let verticalConstraint = saveContentButton.topAnchor.constraint(equalTo: contentTitleTextField.bottomAnchor, constant: 200)
        let heightConstraint = saveContentButton.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = saveContentButton.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
    
    func cancelWasPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveContentPressed() {
        
        if contentTitleTextField.text == "" {
            
            let alert = UIAlertController(title: "Required Field", message: "Please enter a title for this content", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let dataController = DataController.sharedInstance
            
            guard let content = NSEntityDescription.insertNewObject(forEntityName: "Content", into: dataController.managedObjectContext) as? Content else {
                let alert = UIAlertController(title: "Error", message: "Error adding content", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            content.title = contentTitleTextField.text
            content.url = contentURL
            content.dateAdded = NSDate()
            content.type = (contentType?.rawValue)!
            let uuid = UUID().uuidString
            content.uniqueFileName = String(describing: uuid)
            content.addToStudentContent(student!)
            
            let imageGetter = ImageGetter(imageName: content.uniqueFileName!, imageURL: URL(string: content.url!)!)
            imageGetter.downloadAndSaveImage()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentAdded"), object: nil)
            
            dataController.saveContext()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
}
