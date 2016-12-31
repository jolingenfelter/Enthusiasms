//
//  TeacherCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/19/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class TeacherCollectionViewController: UICollectionViewController {
    
    var student: Student?
    var settingsViewController = UIViewController()
    var settingsBarButton = UIBarButtonItem()
    var contentsArray = [Content]()
    var addContentBarButton = UIBarButtonItem()
    var selectedContent: Content?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
         updateContents()
        
        // Collection View setup
    
        self.title = student?.name
        self.collectionView?.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        navigationBarSetup()
        
        // Notification observer to update name if edited
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentName), name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
        
        // Notification observer to update collectionView when content is added
        NotificationCenter.default.addObserver(self, selector: #selector(updateContents), name: NSNotification.Name(rawValue: "ContentUpdate"), object: nil)
        
        // Notification observer to update contentTitle after edit
        NotificationCenter.default.addObserver(self, selector: #selector(updateTitle), name: NSNotification.Name(rawValue: "ContentTitleUpdate"), object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ContentUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ContentTitleUpdate"), object: nil)
    }
    
    func updateContents() {
        
        guard let student = student, let contents = student.contents else {
            return
        }
        
        contentsArray = contents.sortedArray(using: [NSSortDescriptor.init(key: "title", ascending: true)]) as! [Content]
        
        collectionView?.reloadData()
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
    
    func setupSettingsVC() {
        // ViewController setup
        settingsViewController = UIViewController()
        let editName = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        editName.setTitle("Edit Student Name", for: .normal)
        editName.setTitleColor(UIColor.black, for: .normal)
        editName.isEnabled = true
        editName.addTarget(self, action: #selector(editStudentName), for: .touchUpInside)
        settingsViewController.view.addSubview(editName)
        
        // Button constraints
        editName.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = editName.centerXAnchor.constraint(equalTo: settingsViewController.view.centerXAnchor)
        let verticalConstraint = editName.centerYAnchor.constraint(equalTo: settingsViewController.view.centerYAnchor)
        let heightConstraint = editName.heightAnchor.constraint(equalToConstant: 50)
        let widthConstraint = editName.widthAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
        
        // PopoverView setup
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popover = settingsViewController.popoverPresentationController! as UIPopoverPresentationController
        popover.barButtonItem = settingsBarButton
        settingsViewController.preferredContentSize = CGSize(width: 200, height: 50)
        settingsViewController.popoverPresentationController?.permittedArrowDirections = .up
    }
    
    func editStudentName() {
        let editNameViewController = EditNameViewController()
        editNameViewController.modalTransitionStyle = .coverVertical
        editNameViewController.modalPresentationStyle = .formSheet
        editNameViewController.student = student
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(editNameViewController, animated: true, completion: nil)
    }
    
    func updateStudentName() {
        if let student = student {
            if let studentName = student.name {
                self.title = studentName
            }
        }
    }

    func settingsPressed() {
        setupSettingsVC()
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    func addPressed() {
        
        let menuViewController = UIViewController()
        menuViewController.modalPresentationStyle = .popover
        menuViewController.popoverPresentationController?.barButtonItem = addContentBarButton
        menuViewController.preferredContentSize = CGSize(width: 200, height: 150)
        
        let contentFromWebButton = UIButton()
        let separator = UIView()
        let contentFromLibraryButton = UIButton()
        
        contentFromWebButton.setTitle("Web Content", for: .normal)
        contentFromWebButton.setTitleColor(UIColor.black, for: .normal)
        contentFromWebButton.addTarget(self, action: #selector(contentFromWebPressed), for: .touchUpInside)
        menuViewController.view.addSubview(contentFromWebButton)
        
        separator.backgroundColor = UIColor.lightGray
        menuViewController.view.addSubview(separator)
        
        contentFromLibraryButton.setTitle("Content from library", for: .normal)
        contentFromLibraryButton.setTitleColor(UIColor.black, for: .normal)
        contentFromLibraryButton.addTarget(self, action: #selector(contentFromLibraryPressed), for: .touchUpInside)
        menuViewController.view.addSubview(contentFromLibraryButton)
        
        let buttonHeight: CGFloat = 75
        let buttonWidth: CGFloat = 200
        
        contentFromWebButton.translatesAutoresizingMaskIntoConstraints = false
        
        let contentFromWebHorizontalConstraint = contentFromWebButton.centerXAnchor.constraint(equalTo: menuViewController.view.centerXAnchor)
        let contentFromWebVerticalConstraint = contentFromWebButton.bottomAnchor.constraint(equalTo: separator.topAnchor)
        let contentFromWebHeightConstraint = contentFromWebButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let contentFromWebWidthConstraint = contentFromWebButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([contentFromWebHorizontalConstraint, contentFromWebVerticalConstraint, contentFromWebHeightConstraint, contentFromWebWidthConstraint])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorLeadingConstraint = separator.leadingAnchor.constraint(equalTo: menuViewController.view.leadingAnchor)
        let separatorTrailingConstraint = separator.trailingAnchor.constraint(equalTo: menuViewController.view.trailingAnchor)
        let separatorVerticalConstraint = separator.centerYAnchor.constraint(equalTo: menuViewController.view.centerYAnchor)
        let separatorHeightConstraint = separator.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([separatorLeadingConstraint, separatorTrailingConstraint, separatorVerticalConstraint, separatorHeightConstraint])
        
        contentFromLibraryButton.translatesAutoresizingMaskIntoConstraints = false
        
        let contentFromLibraryHorizontalConstraint = contentFromLibraryButton.centerXAnchor.constraint(equalTo: menuViewController.view.centerXAnchor)
        let contentFromLibraryVerticalConstraint = contentFromLibraryButton.topAnchor.constraint(equalTo: separator.bottomAnchor)
        let contentFromLibraryHeightConstraint = contentFromLibraryButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let contentFromLibraryWidthConstraint = contentFromLibraryButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([contentFromLibraryHorizontalConstraint, contentFromLibraryVerticalConstraint, contentFromLibraryHeightConstraint, contentFromLibraryWidthConstraint])
        
        self.present(menuViewController, animated: true, completion: nil)
    }
    
    func contentFromWebPressed() {
        let getContentView = GetWebContentViewController()
        getContentView.student = student
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(getContentView, animated: true, completion: nil)
    }
    
    func contentFromLibraryPressed() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 300, height: 300)
        flowLayout.sectionInset = UIEdgeInsets(top: 40, left: 10, bottom: 10, right: 10)
        let addContentFromLibraryVC = AddContentFromLibraryViewController(collectionViewLayout: flowLayout)
        addContentFromLibraryVC.student = student
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return contentsArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ContentCollectionViewCell
        
        let content = contentsArray[indexPath.item]
        cell.titleLabel.text = content.title
        
        if let contentImageName = content.uniqueFileName, let imageURL = content.url {
            let imageGetter = ImageGetter(imageName: contentImageName, imageURL: URL(string: imageURL)!)
            cell.thumbnail.image = imageGetter.getImage()
            
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedContent = contentsArray[indexPath.row]
        showMenufor(objectAtIndexPath: indexPath)
    }
    
    func showMenufor(objectAtIndexPath indexPath: IndexPath) {
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! ContentCollectionViewCell
        
        let menu = UIViewController()
        menu.modalPresentationStyle = .popover
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        menu.popoverPresentationController?.sourceView = cell
        menu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        menu.preferredContentSize = CGSize(width: 200, height: 200)
        
        
        let removeButton = UIButton()
        if let student = student, let studentName = student.name {
            removeButton.setTitle("Remove from \(studentName)", for: .normal)
        }
        removeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        removeButton.setTitleColor(.black, for: .normal)
        removeButton.addTarget(self, action: #selector(removeContentFromStudent), for: .touchUpInside)
        menu.view.addSubview(removeButton)
        
        let separator1 = UIView()
        separator1.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator1)
        
        let viewContentButton = UIButton()
        viewContentButton.setTitle("View", for: .normal)
        viewContentButton.setTitleColor(.black, for: .normal)
        viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        menu.view.addSubview(viewContentButton)
        
        let separator2 = UIView()
        separator2.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator2)
        
        let changeTitleButton = UIButton()
        changeTitleButton.setTitle("Change Title", for: .normal)
        changeTitleButton.setTitleColor(.black, for: .normal)
        changeTitleButton.addTarget(self, action: #selector(changeTitle), for: .touchUpInside)
        menu.view.addSubview(changeTitleButton)
        
        let buttonHeight: CGFloat = 60
        let buttonWidth: CGFloat = 200
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let removeHorizontalConstraint = removeButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let removeVerticalConstraint = removeButton.bottomAnchor.constraint(equalTo: separator1.topAnchor)
        let removeHeightConstraint = removeButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let removeWidthConstraint = removeButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([removeHorizontalConstraint, removeVerticalConstraint, removeHeightConstraint, removeWidthConstraint])
        
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        let separator1LeadingConstraint = separator1.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor)
        let separator1TrailingConstraint = separator1.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor)
        let separator1VerticalConstraint = separator1.bottomAnchor.constraint(equalTo: viewContentButton.topAnchor)
        let separator1HeightConstraint = separator1.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([separator1LeadingConstraint, separator1TrailingConstraint, separator1VerticalConstraint, separator1HeightConstraint])
        
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let viewContentHorizontalConstraint = viewContentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let viewContentVerticalConstraint = viewContentButton.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor)
        let viewContentHeightConstraint = viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let viewContentWidthConstraint = viewContentButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([viewContentHorizontalConstraint, viewContentVerticalConstraint, viewContentHeightConstraint, viewContentWidthConstraint])
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        let separator2LeadingConstraint = separator2.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor)
        let separator2TrailingConstraint = separator2.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor)
        let separator2VerticalConstraint = separator2.topAnchor.constraint(equalTo: viewContentButton.bottomAnchor)
        let separator2HeightCOnstraint = separator2.heightAnchor.constraint(equalToConstant: 1)
        
        NSLayoutConstraint.activate([separator2LeadingConstraint, separator2TrailingConstraint, separator2VerticalConstraint, separator2HeightCOnstraint])
        
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        let changeTitleHorizontalConstraint = changeTitleButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let changeTitleVerticalConstraint = changeTitleButton.topAnchor.constraint(equalTo: separator2.bottomAnchor)
        let changeTitleHeightConstraint = changeTitleButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let changeTitleWidthConstraint = changeTitleButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([changeTitleHorizontalConstraint, changeTitleVerticalConstraint, changeTitleHeightConstraint, changeTitleWidthConstraint])
        
        self.present(menu, animated: true, completion: nil)
    }
    
    func removeContentFromStudent() {
        selectedContent?.removeFromStudentContent(student!)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentUpdate"), object: nil)
        let dataController = DataController.sharedInstance
        dataController.saveContext()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func viewContent() {
        
        guard let selectedContent = selectedContent else {
            return
        }
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        viewFullScreen(content: selectedContent, from: self, with: nil,and: nil)
    }
    
    func changeTitle () {
        let editContentViewController = EditContentTitleViewController()
        editContentViewController.modalPresentationStyle = .formSheet
        editContentViewController.content = selectedContent
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        self.present(editContentViewController, animated: true, completion: nil)
    }
    
    func updateTitle () {
        self.collectionView?.reloadData()
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
