//
//  AllContentCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class AllContentCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController = { () -> NSFetchedResultsController<Content> in
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    var cancelButton = UIBarButtonItem()
    let menu = UIViewController()
    var selectedContent: Content?
    let studentListPopover = AddContentToStudentPopoverViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // CollectionView setup
        self.collectionView?.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        self.title = "All Content"
        
        // FetchedResultsController
        fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Error fetching item objects \(error.localizedDescription), \(error.userInfo)")
        }
        
        // Notification for selected student
         NotificationCenter.default.addObserver(self, selector: #selector(studentSelected), name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
        
        // NavBar
        let addContentButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContent))
        self.navigationItem.rightBarButtonItem = addContentButton
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addContent() {
        let getWebContentViewController = GetWebContentViewController()
        self.present(getWebContentViewController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContentCollectionViewCell
    
        let content = fetchedResultsController.object(at: indexPath) as Content
        
        if let contentImageName = content.uniqueFileName, let imageURL = content.url {
            let imageGetter = ImageGetter(imageName: contentImageName, imageURL: URL(string: imageURL)!)
            cell.thumbnail.image = imageGetter.getImage()
        }
        
        cell.titleLabel.text = content.title
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedContent = fetchedResultsController.object(at: indexPath)
        showMenufor(cellAtIndexPath: indexPath)
    }
    
    func showMenufor(cellAtIndexPath indexPath: IndexPath) {
        
        let addToStudentButton = UIButton()
        let changeTitleButton = UIButton()
        let deleteButton = UIButton()
        
        addToStudentButton.setTitle("Add to student", for: .normal)
        addToStudentButton.setTitleColor(UIColor.black, for: .normal)
        addToStudentButton.addTarget(self, action: #selector(addToStudentPressed), for: .touchUpInside)
        
        changeTitleButton.setTitle("Change title", for: .normal)
        changeTitleButton.setTitleColor(UIColor.black, for: .normal)
        changeTitleButton.addTarget(self, action: #selector(changeTitlePressed), for: .touchUpInside)
        
        deleteButton.setTitle("Delete Content", for: .normal)
        deleteButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteContent), for: .touchUpInside)
        
        menu.view.addSubview(addToStudentButton)
        menu.view.addSubview(changeTitleButton)
        menu.view.addSubview(deleteButton)
        
        let separator1 = UIView()
        separator1.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator1)
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator2)
        
        menu.modalPresentationStyle = .popover
        menu.preferredContentSize = CGSize(width: 200, height: 200)
        
        let cell = self.collectionView?.cellForItem(at: indexPath)
        menu.popoverPresentationController?.sourceRect = CGRect(x: 220, y: 150, width: 0, height: 0)
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .up, .right]
        menu.popoverPresentationController?.sourceView = cell
        
        //Menu layout
        addToStudentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let addToStudentHorizontalConstraint = addToStudentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let addToStudentVerticalConstraint = addToStudentButton.bottomAnchor.constraint(equalTo: separator1.topAnchor, constant: -15)
        let addToStudentHeightConstraint = addToStudentButton.heightAnchor.constraint(equalToConstant: 40)
        let addToStudentWidthConstraint = addToStudentButton.widthAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([addToStudentHorizontalConstraint, addToStudentVerticalConstraint, addToStudentHeightConstraint, addToStudentWidthConstraint])
        
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1LeadingConstraint = separator1.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor)
        let separator1TrailingConstraint = separator1.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor)
        let separator1VerticalConstraint = separator1.bottomAnchor.constraint(equalTo: changeTitleButton.topAnchor, constant: -15)
        let separator1HeightConstraint = separator1.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([separator1LeadingConstraint, separator1TrailingConstraint, separator1HeightConstraint, separator1VerticalConstraint])
        
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        let changeTitleHorizontalConstraint = changeTitleButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let changeTitleVerticalConstraint = changeTitleButton.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor)
        let changeTitleHeightConstraint = changeTitleButton.heightAnchor.constraint(equalToConstant: 40)
        let changeTitleWidthConstraint = changeTitleButton.widthAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([changeTitleHorizontalConstraint, changeTitleVerticalConstraint, changeTitleHeightConstraint, changeTitleWidthConstraint])
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2LeadingConstraint = separator2.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor)
        let separator2TrailingConstraint = separator2.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor)
        let separator2VerticalConstraint = separator2.topAnchor.constraint(equalTo: changeTitleButton.bottomAnchor, constant: 15)
        let separator2HeightConstraint = separator2.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([separator2LeadingConstraint, separator2TrailingConstraint, separator2VerticalConstraint, separator2HeightConstraint])
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let deleteButtonHorizontalConstraint = deleteButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let deleteButtonVerticalConstraint = deleteButton.topAnchor.constraint(equalTo: separator2.bottomAnchor, constant: 15)
        let deleteButtonHeightConstraint = deleteButton.heightAnchor.constraint(equalToConstant: 40)
        let deleteButtonWidthConstraint = deleteButton.widthAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([deleteButtonHorizontalConstraint, deleteButtonVerticalConstraint, deleteButtonHeightConstraint, deleteButtonWidthConstraint])
        
         self.present(menu, animated: true, completion: nil)
    }
    
    func addToStudentPressed() {
        studentListPopover.modalPresentationStyle = .popover
        studentListPopover.popoverPresentationController?.sourceView = menu.view
        studentListPopover.popoverPresentationController?.sourceRect = CGRect(x: 180, y: 40, width: 0, height: 0)
        studentListPopover.preferredContentSize = CGSize(width: 180, height: 180)
        studentListPopover.popoverPresentationController?.permittedArrowDirections = [.left, .up]
        self.presentedViewController?.present(studentListPopover, animated: true, completion: nil)
    }
    
    func studentSelected() {
        let studentAddingContentTo = studentListPopover.selectedStudent
        studentAddingContentTo?.addToContents(selectedContent!)
        let dataController = DataController.sharedInstance
        dataController.saveContext()
    }
    
    func changeTitlePressed() {
        
    }
    
    func deleteContent() {
        let deleteAlert = UIAlertController(title: "Delete this content", message: "Are you sure you want to delete this content from the app?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { alert in
            let dataController = DataController.sharedInstance
            dataController.managedObjectContext.delete(self.selectedContent!)
            dataController.saveContext()
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        })
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        deleteAlert.addAction(noAction)
        deleteAlert.addAction(yesAction)
        self.presentedViewController?.present(deleteAlert, animated: true, completion: nil)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }

}
