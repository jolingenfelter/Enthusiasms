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
    let instructionsLabel = UILabel()

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
        
        // InstructionsLabel
        instructionsLabel.text = "Tap '+' to add content"
        instructionsLabel.textColor = UIColor.white
        instructionsLabel.font = instructionsLabel.font.withSize(40)
        self.view.addSubview(instructionsLabel)
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraint = instructionsLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = instructionsLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let heightConstraint = instructionsLabel.heightAnchor.constraint(equalToConstant: 200)
        let widthConstraint = instructionsLabel.widthAnchor.constraint(equalToConstant: 400)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        
        presentInstructionLabel()

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AddContentToSelectedStudent"), object: nil)
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
    
    func addContent() {
        let getWebContentViewController = GetWebContentViewController()
        let navigationController = UINavigationController(rootViewController: getWebContentViewController)
        self.present(navigationController, animated: true, completion: nil)
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

        showMenufor(cellAtIndexPath: indexPath)
    }
    
    func showMenufor(cellAtIndexPath indexPath: IndexPath) {
        
        let viewContentButton = UIButton()
        let addToStudentButton = UIButton()
        let changeTitleButton = UIButton()
        let deleteButton = UIButton()
        
        viewContentButton.setTitle("View", for: .normal)
        viewContentButton.setTitleColor(.black, for: .normal)
        viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        
        addToStudentButton.setTitle("Add to student", for: .normal)
        addToStudentButton.setTitleColor(UIColor.black, for: .normal)
        addToStudentButton.addTarget(self, action: #selector(addToStudentPressed), for: .touchUpInside)
        
        changeTitleButton.setTitle("Change title", for: .normal)
        changeTitleButton.setTitleColor(UIColor.black, for: .normal)
        changeTitleButton.addTarget(self, action: #selector(changeTitlePressed), for: .touchUpInside)
        
        deleteButton.setTitle("Delete Content", for: .normal)
        deleteButton.setTitleColor(UIColor.black, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteContent), for: .touchUpInside)
        
        menu.view.addSubview(viewContentButton)
        menu.view.addSubview(addToStudentButton)
        menu.view.addSubview(changeTitleButton)
        menu.view.addSubview(deleteButton)
        
        let separator1 = UIView()
        separator1.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator1)
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator2)
        
        let separator3 = UIView()
        separator3.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator3)
        
        menu.modalPresentationStyle = .popover
        menu.preferredContentSize = CGSize(width: 200, height: 220)
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! ContentCollectionViewCell
        menu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .up, .right]
        menu.popoverPresentationController?.sourceView = cell
        
        //Menu layout
        
        let buttonHeight: CGFloat = 50
        
        
        // ViewContentButton
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContentButton.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            viewContentButton.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            viewContentButton.bottomAnchor.constraint(equalTo: separator1.topAnchor),
            viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        
        // Separator 1
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator1.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            separator1.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1),
            separator1.bottomAnchor.constraint(equalTo: addToStudentButton.topAnchor)
            ])
       
        
        // AddToStudentButton
        addToStudentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addToStudentButton.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            addToStudentButton.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            addToStudentButton.bottomAnchor.constraint(equalTo: separator2.topAnchor),
            addToStudentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator2
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator2.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            separator2.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ChangeTitleButton
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeTitleButton.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            changeTitleButton.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            changeTitleButton.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            changeTitleButton.heightAnchor.constraint(equalToConstant: buttonHeight)
            ])
        
        // Separator3
        separator3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator3.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            separator3.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            separator3.heightAnchor.constraint(equalToConstant: 1),
            separator3.topAnchor.constraint(equalTo: changeTitleButton.bottomAnchor)
            ])
        
        // DeleteButton
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            deleteButton.topAnchor.constraint(equalTo: separator3.bottomAnchor)
            ])
        
         self.present(menu, animated: true, completion: nil)
    }
    
    func addToStudentPressed() {
        
        studentListPopover.modalPresentationStyle = .popover
        studentListPopover.popoverPresentationController?.sourceView = menu.view
        studentListPopover.popoverPresentationController?.sourceRect = CGRect(x: 180, y: 80, width: 0, height: 0)
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
        
        let editContentViewController = EditContentTitleViewController()
        
        editContentViewController.modalPresentationStyle = .formSheet
        editContentViewController.content = selectedContent
        
        menu.dismiss(animated: false, completion: nil)
        
        self.present(editContentViewController, animated: true, completion: nil)
    }
    
    func deleteContent() {
        
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        presentInstructionLabel()
        collectionView?.reloadData()
        
    }
    
    func viewContent() {
        
        guard let selectedContent = selectedContent else {
            return
        }
        
        menu.dismiss(animated: false, completion: nil)
        viewFullScreen(content: selectedContent, from: self)
    
    }
        
}


