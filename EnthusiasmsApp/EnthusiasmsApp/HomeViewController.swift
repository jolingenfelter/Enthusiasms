//
//  ViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    lazy var  childButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Child", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = button.titleLabel?.font.withSize(50)
        button.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(childPressed), for: .touchUpInside)
        self.view.addSubview(button)
        
        return button
        
    }()
    
    lazy var caretakerButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Caretaker", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = button.titleLabel?.font.withSize(50)
        button.backgroundColor = UIColor(red: 79/255.0, green: 176/255.0, blue: 255/255.0, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(caretakerPressed), for: .touchUpInside)
        self.view.addSubview(button)
        
        return button
        
    }()
    
    lazy var enthusiasmsLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Enthusiasms"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.font = label.font.withSize(130)
        self.view.addSubview(label)
        
        return label
        
    }()
    
    var fetchedStudents: [Student] = []
    
    let studentListPopover = StudentListPopover()
    
    let dataController: DataController
    
    init(dataController: DataController = DataController.sharedInstance) {
        self.dataController = dataController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(studentSelected), name: NSNotification.Name(rawValue: "StudentSelected"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StudentSelected"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
        
        let managedObjectContext = dataController.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = Student.fetchRequest()
        
        do {
            fetchedStudents = try managedObjectContext.fetch(request) as! [Student]
        } catch let error {
            print(error)
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        labelConstraints()
        buttonConstraints()
    }
    
    func labelConstraints() {
        
        enthusiasmsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            enthusiasmsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enthusiasmsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160)
            ])
    }
    
    func buttonConstraints() {
        
        // Caretaker Button
        caretakerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            caretakerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            caretakerButton.topAnchor.constraint(equalTo: enthusiasmsLabel.bottomAnchor, constant: 200),
            caretakerButton.heightAnchor.constraint(equalToConstant: 90),
            caretakerButton.widthAnchor.constraint(equalToConstant: 400)
            ])
        
        // Child Button
        childButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            childButton.topAnchor.constraint(equalTo: caretakerButton.bottomAnchor, constant: 30),
            childButton.heightAnchor.constraint(equalTo: caretakerButton.heightAnchor),
            childButton.widthAnchor.constraint(equalTo: caretakerButton.widthAnchor)
            ])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func caretakerPressed() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = 0
        
        let studentListViewController = StudentListViewController()
        
        self.navigationController?.pushViewController(studentListViewController, animated: true)
    }

    @objc func childPressed() {
        
        if fetchedStudents.count == 0 {
            
            let alertController = UIAlertController(title: "No Children", message: "Enter as a caretaker to get started", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            studentListPopover.preferredContentSize = CGSize(width: 200, height: 200)
            studentListPopover.modalPresentationStyle = UIModalPresentationStyle.popover
            studentListPopover.popoverPresentationController?.permittedArrowDirections = .left
            
            let popover = studentListPopover.popoverPresentationController! as UIPopoverPresentationController
            popover.sourceView = self.childButton
            popover.sourceRect = CGRect(x: 300, y: 50, width: 0, height: 0)
            
            self.navigationController?.present(studentListPopover, animated: true, completion: nil)
            }
        
    }
    
    @objc func studentSelected() {
        
        let timerViewController = SetTimerViewController()
        timerViewController.student = studentListPopover.selectedStudent
        
        self.navigationController?.pushViewController(timerViewController, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

