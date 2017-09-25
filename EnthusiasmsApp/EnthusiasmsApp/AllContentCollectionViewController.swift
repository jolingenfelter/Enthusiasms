//
//  AllContentCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

public let reuseIdentifier = "Cell"

class AllContentCollectionViewController: UICollectionViewController {
    
    lazy var fetchedResultsController = { () -> NSFetchedResultsController<Content> in
        let request: NSFetchRequest<Content> = Content.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        let managedObjectContext = DataController.sharedInstance.managedObjectContext
        let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    var cancelButton = UIBarButtonItem()
    let menu = AllContentMenu()
    var selectedContent: Content?
    let studentListPopover = AddContentToStudentPopoverViewController()
    
    lazy var instructionsLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Tap '+' to add content"
        label.textColor = UIColor.white
        label.font = label.font.withSize(40)
        self.view.addSubview(label)
        
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        // CollectionView setup
        self.collectionView?.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        self.title = "Content Library"
        
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
        
        presentInstructionLabel()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = instructionsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = instructionsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let heightConstraint = instructionsLabel.heightAnchor.constraint(equalToConstant: 200)
        let widthConstraint = instructionsLabel.widthAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])

        
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
    
    @objc func addContent() {
        let getWebContentViewController = GetWebContentViewController()
        let navigationController = UINavigationController(rootViewController: getWebContentViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: Menu Button Setup
    
    func menuButtonSetup() {
        
        menu.viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        menu.addToStudentButton.addTarget(self, action: #selector(addToStudentPressed), for: .touchUpInside)
        menu.changeTitleButton.addTarget(self, action: #selector(changeTitlePressed), for: .touchUpInside)
        menu.deleteButton.addTarget(self, action: #selector(deleteContent), for: .touchUpInside)
        
    }
    
    @objc func addToStudentPressed() {
        
        studentListPopover.modalPresentationStyle = .popover
        studentListPopover.popoverPresentationController?.sourceView = menu.view
        studentListPopover.popoverPresentationController?.sourceRect = CGRect(x: 180, y: 80, width: 0, height: 0)
        studentListPopover.preferredContentSize = CGSize(width: 180, height: 180)
        studentListPopover.popoverPresentationController?.permittedArrowDirections = [.left, .up]
        
        self.presentedViewController?.present(studentListPopover, animated: true, completion: nil)
    }
    
    @objc func studentSelected() {
        
        let studentAddingContentTo = studentListPopover.selectedStudent
        studentAddingContentTo?.addToContents(selectedContent!)
        
        DataController.sharedInstance.saveContext()
    }
    
    @objc func changeTitlePressed() {
        
        let editContentViewController = EditContentTitleViewController()
        
        editContentViewController.modalPresentationStyle = .formSheet
        editContentViewController.content = selectedContent
        
        menu.dismiss(animated: false, completion: nil)
        
        self.present(editContentViewController, animated: true, completion: nil)
    }
    
    @objc func deleteContent() {
        
        let deleteAlert = UIAlertController(title: "Delete this content?", message: "Are you sure you want to delete this content from the app?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { alert in
            
            if let fileName = self.selectedContent?.uniqueFileName {
                
                DataController.sharedInstance.managedObjectContext.delete(self.selectedContent!)
                DataController.sharedInstance.saveContext()
                
                deleteFile(named: fileName)
            }
            
            
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        })
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        deleteAlert.addAction(noAction)
        deleteAlert.addAction(yesAction)
        
        menu.dismiss(animated: false, completion: nil)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    @objc func viewContent() {
        
        guard let selectedContent = selectedContent else {
            return
        }
        
        menu.dismiss(animated: false, completion: nil)
        viewFullScreen(content: selectedContent, from: self)
        
    }

        
}

// MARK: UITableViewDataSource & Delegate

extension AllContentCollectionViewController {
    
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
        
        guard let imageName = content.uniqueFileName else {
            let imageSaver = ContentImageSaver(content: content)
            imageSaver.downloadNameAndSaveImage()
            return cell
        }
        
        cell.thumbnail.image = getImage(imageName: imageName)
        cell.titleLabel.text = content.title
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedContent = fetchedResultsController.object(at: indexPath)
        
        show(menu: menu, ofSize: CGSize(width: 200, height: 220), forCellAtIndexPath: indexPath)
    }
    
    func show(menu: UIViewController, ofSize size: CGSize, forCellAtIndexPath indexPath: IndexPath) {
        
        menuButtonSetup()
        
        menu.modalPresentationStyle = .popover
        menu.preferredContentSize = size
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! ContentCollectionViewCell
        menu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        menu.popoverPresentationController?.sourceView = cell
        
        self.present(menu, animated: true, completion: nil)
    }
    
}

// MARK: NSFetchedResultsControllerDelegate

extension AllContentCollectionViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        presentInstructionLabel()
        collectionView?.reloadData()
        
    }
    
}


