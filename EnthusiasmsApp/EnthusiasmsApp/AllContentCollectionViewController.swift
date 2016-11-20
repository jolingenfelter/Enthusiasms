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
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let deleteButton = UIButton()
        
        addToStudentButton.setTitle("Add to student", for: .normal)
        addToStudentButton.setTitleColor(UIColor.black, for: .normal)
        addToStudentButton.addTarget(self, action: #selector(addToStudentPressed), for: .touchUpInside)
        
        menu.view.addSubview(addToStudentButton)
        menu.view.addSubview(deleteButton)
        
        menu.modalPresentationStyle = .popover
        menu.preferredContentSize = CGSize(width: 200, height: 200)
        
        let cell = self.collectionView?.cellForItem(at: indexPath)
        menu.popoverPresentationController?.sourceRect = CGRect(x: 220, y: 150, width: 0, height: 0)
        menu.popoverPresentationController?.permittedArrowDirections = .left
        menu.popoverPresentationController?.sourceView = cell
        
        //View layout
        addToStudentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let addToStudentHorizontalConstraint = addToStudentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let addToStudentVerticalConstraint = addToStudentButton.topAnchor.constraint(equalTo: menu.view.topAnchor, constant: 20)
        let addToStudentHeightConstraint = addToStudentButton.heightAnchor.constraint(equalToConstant: 40)
        let addToStudentWidthConstraint = addToStudentButton.widthAnchor.constraint(equalToConstant: 150)
        
        NSLayoutConstraint.activate([addToStudentHorizontalConstraint, addToStudentVerticalConstraint, addToStudentHeightConstraint, addToStudentWidthConstraint])
        
        self.present(menu, animated: false, completion: nil)
    }
    
    func addToStudentPressed() {
        studentListPopover.modalPresentationStyle = .popover
        studentListPopover.popoverPresentationController?.sourceView = menu.view
        studentListPopover.popoverPresentationController?.sourceRect = CGRect(x: 180, y: 140, width: 0, height: 0)
        studentListPopover.preferredContentSize = CGSize(width: 200, height: 200)
        studentListPopover.popoverPresentationController?.permittedArrowDirections = .left
        self.presentedViewController?.present(studentListPopover, animated: true, completion: nil)
    }
    
    func studentSelected() {
        let studentAddingContentTo = studentListPopover.selectedStudent
        studentAddingContentTo?.addToContents(selectedContent!)
    }

}
