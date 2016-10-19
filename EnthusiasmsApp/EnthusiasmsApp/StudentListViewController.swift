//
//  StudentListViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/18/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class StudentListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var settingsButton = UIBarButtonItem()
    var addButton = UIBarButtonItem()
    
    var settingsViewController = UIViewController()
    
    lazy var fetchedResultsController = { () -> NSFetchedResultsController<Student> in
        let request: NSFetchRequest<Student> = Student.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavBar
        settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsWasPressed))
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStudentPressed))
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 20
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItems = [spaceItem, settingsButton]
        self.navigationItem.rightBarButtonItem = addButton


        // TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // FetchedResultsController
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print ("Error fetching Item  objects \(error.localizedDescription), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
    }
    
    
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let student = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = student.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = fetchedResultsController.object(at: indexPath)
        let teacherCollectionViewController = TeacherCollectionViewController(collectionViewLayout: .init())
        teacherCollectionViewController.student = student
        self.navigationController?.pushViewController(teacherCollectionViewController, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let student = fetchedResultsController.object(at: indexPath)
        let dataController = DataController.sharedInstance
        dataController.managedObjectContext.delete(student)
        
        dataController.saveContext()
    }


    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    // MARK: NavBar Actions
    
    func setupSettingsVC() {
        // ViewController setup
        settingsViewController = UIViewController()
        let editPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        editPasswordButton.setTitle("Edit Password", for: .normal)
        editPasswordButton.setTitleColor(UIColor.black, for: .normal)
        editPasswordButton.isEnabled = true
        editPasswordButton.addTarget(self, action: #selector(editPasswordWasPressed), for: .touchUpInside)
        settingsViewController.view.addSubview(editPasswordButton)
        
        // Button constraints
        editPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = editPasswordButton.centerXAnchor.constraint(equalTo: settingsViewController.view.centerXAnchor)
        let verticalConstraint = editPasswordButton.centerYAnchor.constraint(equalTo: settingsViewController.view.centerYAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
        // PopoverView setup
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = settingsViewController.popoverPresentationController! as UIPopoverPresentationController
        popover.barButtonItem = settingsButton
        settingsViewController.preferredContentSize = CGSize(width: 150, height: 50)
        settingsViewController.popoverPresentationController?.permittedArrowDirections = .up
    }
    
    func editPasswordWasPressed() {
        let editPasswordViewController = EditPasswordViewController()
        self.presentedViewController?.present(editPasswordViewController, animated: true, completion: nil)
    }
    
    func settingsWasPressed() {
        setupSettingsVC()
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    func addStudentPressed() {
        let createStudentViewController = CreateStudentViewController()
        createStudentViewController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(createStudentViewController, animated: false, completion: nil)
    }

}
