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
    
    var studentName = String()
    
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
    
    @IBAction func addStudentPressed(_ sender: AnyObject) {
        let createStudentPopover = self.storyboard?.instantiateViewController(withIdentifier: "createStudentPopver") as! CreateStudentPopoverViewController
        createStudentPopover.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(createStudentPopover, animated: false, completion: nil)
    }
    
    @IBAction func homeWasPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}
