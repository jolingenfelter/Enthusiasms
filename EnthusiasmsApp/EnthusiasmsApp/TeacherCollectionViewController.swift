//
//  TeacherCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

class TeacherCollectionViewController: UICollectionViewController, DownloadableImage {
    
    let student: Student
    let imageGetter: ImageGetter
    let dataController: DataController
    var settingsBarButton = UIBarButtonItem()
    var contentsArray = [Content]()
    var addContentBarButton = UIBarButtonItem()
    var selectedContent: Content?
    
    lazy var instructionsLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Tap '+' to add content"
        label.textColor = UIColor.white
        label.font = label.font.withSize(40)
        label.textAlignment = .center
        self.view.addSubview(label)
        
        return label
    }()
    
    init(student: Student, collectionViewLayout: UICollectionViewFlowLayout, imageGetter: ImageGetter = ImageGetter.sharedInstance, dataController: DataController = DataController.sharedInstance) {
        self.student = student
        self.imageGetter = imageGetter
        self.dataController = dataController
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Collection View setup
    
        self.title = student.name
        self.collectionView?.backgroundColor = UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        navigationBarSetup()
        
        updateContents()
        
        // Notification observer to update name if edited
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentName), name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
        
        // Notification observer to update collectionView when content is added
        NotificationCenter.default.addObserver(self, selector: #selector(updateContents), name: NSNotification.Name(rawValue: "ContentUpdate"), object: nil)
        
        // Notification observer to update contentTitle after edit
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name: NSNotification.Name(rawValue: "ContentTitleUpdate"), object: nil)

    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel.heightAnchor.constraint(equalToConstant: 90),
            instructionsLabel.widthAnchor.constraint(equalToConstant: 600)
            ])
        
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ContentUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ContentTitleUpdate"), object: nil)
        
    }
    
    @objc func updateContents() {
        
        guard let contents = student.contents else {
            return
        }
        
        contentsArray = contents.sortedArray(using: [NSSortDescriptor.init(key: "title", ascending: true)]) as! [Content]
        
        DispatchQueue.main.async {
            
            if self.contentsArray.count == 0 {
                self.instructionsLabel.isHidden = false
            } else {
                self.instructionsLabel.isHidden = true
            }
            
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: NavBar Setup
    
    func navigationBarSetup() {
        
        self.navigationItem.leftItemsSupplementBackButton = true
        settingsBarButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsPressed))
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20
        
        addContentBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        
        self.navigationItem.leftBarButtonItems = [space, settingsBarButton]
        self.navigationItem.rightBarButtonItem = addContentBarButton

    }
    
    // MARK: NavBar Actions
    
    func studentsListPressed() {
        
        if let navController = self.navigationController {
            navController.popToRootViewController(animated: true)
        }
        
    }
    
    // Edit Student Name
    
    @objc func editStudentName() {
        
        let editNameViewController = EditNameViewController(student: student)
        editNameViewController.modalTransitionStyle = .coverVertical
        editNameViewController.modalPresentationStyle = .formSheet
        editNameViewController.student = student
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(editNameViewController, animated: true, completion: nil)
        
    }
    
    @objc func updateStudentName() {
        
        if let studentName = student.name {
            self.title = studentName
        }
        
    }

    @objc func settingsPressed() {
        
        let settingsMenu = TeacherSettingsMenu()
        settingsMenu.editNameButton.addTarget(self, action: #selector(editStudentName), for: .touchUpInside)
        
        // PopoverView setup
        settingsMenu.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = settingsMenu.popoverPresentationController! as UIPopoverPresentationController
        popover.barButtonItem = settingsBarButton
        settingsMenu.preferredContentSize = CGSize(width: 200, height: 50)
        settingsMenu.popoverPresentationController?.permittedArrowDirections = .up
        
        self.present(settingsMenu, animated: true, completion: nil)
    }
    
    // Add Content
    
    @objc func addPressed() {
        
        let addContentMenu = TeacherAddContentMenu()
        addContentMenu.modalPresentationStyle = .popover
        addContentMenu.popoverPresentationController?.barButtonItem = addContentBarButton
        addContentMenu.preferredContentSize = CGSize(width: 200, height: 150)

        addContentMenu.contentFromWebButton.addTarget(self, action: #selector(contentFromWebPressed), for: .touchUpInside)
        addContentMenu.contentFromLibraryButton.addTarget(self, action: #selector(contentFromLibraryPressed), for: .touchUpInside)
        
        self.present(addContentMenu, animated: true, completion: nil)
    }
    
    @objc func contentFromWebPressed() {
        
        let getContentView = GetWebContentViewController(student: student)
        let navController = UINavigationController(rootViewController: getContentView)
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func contentFromLibraryPressed() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        
        let addContentFromLibraryVC = AddContentFromLibraryViewController(student: student, flowLayout: flowLayout)

        let navigationController = UINavigationController(rootViewController: addContentFromLibraryVC)
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func homePressed() {
        
        if let navController = self.navigationController {
            
            navController.popToRootViewController(animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Settings Menu
    
    func showMenufor(objectAtIndexPath indexPath: IndexPath) {
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! ContentCollectionViewCell
        let name = student.name!
        
        // Popover Setup
        let menu = TeacherCellMenu(name: name)
        menu.modalPresentationStyle = .popover
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        menu.popoverPresentationController?.sourceView = cell
        menu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        menu.preferredContentSize = CGSize(width: 200, height: 200)
        
        // Button Actions
        menu.removeButton.addTarget(self, action: #selector(removeContentFromStudent), for: .touchUpInside)
        menu.viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        menu.changeTitleButton.addTarget(self, action: #selector(changeTitle), for: .touchUpInside)
        
        self.present(menu, animated: true, completion: nil)
    }
    
    @objc func removeContentFromStudent() {
        
        guard let selectedContent = selectedContent, let studentName = student.name else {
            
            return
            
        }
        
        let alert = UIAlertController(title: "Remove Content?", message: "Are you sure you want to remove this content from \(studentName)? The content will remain available in the Content Library.", preferredStyle: .alert)
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (action) in
            
            selectedContent.removeFromStudentContent(self.student)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentUpdate"), object: nil)
            self.dataController.saveContext()
            self.presentedViewController?.dismiss(animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            self.presentedViewController?.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        self.presentedViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func viewContent() {
        
        guard let selectedContent = selectedContent else {
            return
        }
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        viewFullScreen(content: selectedContent)
    }
    
    @objc func changeTitle () {
        
        let editContentViewController = EditContentTitleViewController(content: selectedContent)
        editContentViewController.modalPresentationStyle = .formSheet
        editContentViewController.content = selectedContent
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(editContentViewController, animated: true, completion: nil)
        
    }
    
    @objc func updateTitle () {
        self.collectionView?.reloadData()
    }

}

 // MARK: UICollectionViewDataSource & Delegate

extension TeacherCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContentCollectionViewCell
        
        let content = contentsArray[indexPath.item]
        cell.titleLabel.text = content.title!
        
        guard let imageName = content.uniqueFileName else {
            
            guard let imageURL = getImageURL(forContent: content) else {
                return cell
            }
            
            saveImageFrom(url: imageURL, forContent: content)
            
            return cell
        }
        
        cell.thumbnail.image = retrieveImage(imageName: imageName)
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedContent = contentsArray[indexPath.row]
        showMenufor(objectAtIndexPath: indexPath)
    }
    
}
