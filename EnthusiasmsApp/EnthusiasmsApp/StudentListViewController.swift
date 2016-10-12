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
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    var studentName = String()
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
        let teacherCollectionViewController = self.storyboard?.instantiateViewController(withIdentifier: "teacherCollectionViewController") as! TeacherCollectionViewController
        teacherCollectionViewController.studentName = student.name!
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
    
    func editPasswordWasPressed() {
        let editPasswordViewController = EditPasswordViewController()
        self.presentingViewController?.dismiss(animated: false, completion: nil)
        editPasswordViewController.modalPresentationStyle = UIModalPresentationStyle.formSheet
        editPasswordViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.view.window?.rootViewController = editPasswordViewController
        self.present(editPasswordViewController, animated: true, completion: nil)
    }
    
    @IBAction func settingsWasPressed(_ sender: AnyObject) {
        
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
        popover.sourceView = self.view
        settingsViewController.popoverPresentationController?.sourceRect = CGRect(x: 50, y: 10, width: 0, height: 0)
        settingsViewController.preferredContentSize = CGSize(width: 150, height: 50)
        settingsViewController.popoverPresentationController?.permittedArrowDirections = .up
        
        self.present(settingsViewController, animated: true, completion: nil)
    
    }
    
    @IBAction func addStudentPressed(_ sender: AnyObject) {
        let createStudentPopover = self.storyboard?.instantiateViewController(withIdentifier: "createStudentPopver") as! CreateStudentPopoverViewController
        createStudentPopover.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(createStudentPopover, animated: false, completion: nil)
    }
    
    @IBAction func homeWasPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
