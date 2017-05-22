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
    var allContentButton = UIBarButtonItem()
    let instructionsLabel = UILabel()
    
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
        allContentButton = UIBarButtonItem(title: "All Content", style: .plain, target: self, action: #selector(allContentPressed))
        
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width = 20
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationItem.leftBarButtonItems = [leftSpaceItem, settingsButton]
        
        let rightSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.navigationItem.rightBarButtonItems = [allContentButton, rightSpaceItem, addButton]


        // TableView
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // FetchedResultsController
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print ("Error fetching item objects \(error.localizedDescription), \(error.userInfo)")
        }
        
        // InstructionsLabel
        instructionsLabel.text = "Tap '+' to add a child"
        instructionsLabel.font = instructionsLabel.font.withSize(40)
        instructionsLabel.backgroundColor = UIColor.white
        instructionsLabel.textColor = UIColor.lightGray
        self.view.addSubview(instructionsLabel)
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel.heightAnchor.constraint(equalToConstant: 80)
            ])
        
        presentInstructionLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func presentInstructionLabel() {
        
        if self.fetchedResultsController.fetchedObjects?.count == 0 {
            instructionsLabel.isHidden = false
        } else {
            instructionsLabel.isHidden = true
        }
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
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let teacherCollectionViewController = TeacherCollectionViewController(student: student, collectionViewLayout: flowLayout)
        
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
        presentInstructionLabel()
    }
    
    // MARK: NavBar Actions
    
    func editPasswordWasPressed() {
        
        let editPasswordViewController = EditPasswordViewController()
        let navigationController = UINavigationController(rootViewController: editPasswordViewController)
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    func settingsWasPressed() {
        
        let settingsMenu = StudentListSettingsMenu()
        settingsMenu.editPasswordButton.addTarget(self, action: #selector(editPasswordWasPressed), for: .touchUpInside)
        
        // PopoverView setup
        settingsMenu.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = settingsMenu.popoverPresentationController! as UIPopoverPresentationController
        popover.barButtonItem = settingsButton
        settingsMenu.preferredContentSize = CGSize(width: 150, height: 50)
        settingsMenu.popoverPresentationController?.permittedArrowDirections = .up
        
        self.present(settingsMenu, animated: true, completion: nil)
        
    }
    
    func addStudentPressed() {
        let createStudentViewController = CreateStudentViewController()
        createStudentViewController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(createStudentViewController, animated: false, completion: nil)
    }
    
    func allContentPressed() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        let allContentViewController = AllContentCollectionViewController(collectionViewLayout: flowLayout)
        
        self.navigationController?.pushViewController(allContentViewController, animated: true)
    }

}
