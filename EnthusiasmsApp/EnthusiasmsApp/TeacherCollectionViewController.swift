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
    let instructionsLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // Collection View setup
    
        self.title = student?.name
        self.collectionView?.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)
        navigationBarSetup()
        
        // InstructionsLabel 
        instructionsLabel.text = "Tap '+' to add content"
        instructionsLabel.textColor = UIColor.white
        instructionsLabel.font = instructionsLabel.font.withSize(40)
        instructionsLabel.textAlignment = .center
        self.view.addSubview(instructionsLabel)
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instructionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            instructionsLabel.heightAnchor.constraint(equalToConstant: 90),
            instructionsLabel.widthAnchor.constraint(equalToConstant: 600)
            ])
        
        updateContents()
        
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
        
        if contentsArray.count == 0 {
            instructionsLabel.isHidden = false
        } else {
            instructionsLabel.isHidden = true
        }
        
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
        let editNameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        
        editNameButton.setTitle("Edit Student Name", for: .normal)
        editNameButton.setTitleColor(UIColor.black, for: .normal)
        editNameButton.isEnabled = true
        editNameButton.addTarget(self, action: #selector(editStudentName), for: .touchUpInside)
        settingsViewController.view.addSubview(editNameButton)
        
        // Button constraints
        editNameButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editNameButton.centerXAnchor.constraint(equalTo: settingsViewController.view.centerXAnchor),
            editNameButton.centerYAnchor.constraint(equalTo: settingsViewController.view.centerYAnchor),
            editNameButton.heightAnchor.constraint(equalToConstant: 50),
            editNameButton.widthAnchor.constraint(equalToConstant: 200)
            ])
        
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
        cell.titleLabel.text = content.title!
        
       
        guard let imageName = content.uniqueFileName else {
            let imageSaver = ContentImageSaver(content: content)
            imageSaver.downloadNameAndSaveImage()
            return cell
        }
    
            cell.thumbnail.image = getImage(imageName: imageName)
        

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
        
        // RemoveButton Constraints
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            removeButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor),
            removeButton.bottomAnchor.constraint(equalTo: separator1.topAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            removeButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        
        // Separator1 Constraints
        separator1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator1.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            separator1.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            separator1.bottomAnchor.constraint(equalTo: viewContentButton.topAnchor),
            separator1.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ViewContentButton Constraints
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewContentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor),
            viewContentButton.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor),
            viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            viewContentButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        
        // Separator 2 Constraints
        separator2.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator2.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor),
            separator2.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor),
            separator2.topAnchor.constraint(equalTo: viewContentButton.bottomAnchor),
            separator2.heightAnchor.constraint(equalToConstant: 1)
            ])
        
        // ChangeTitleButton Constraints
        changeTitleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeTitleButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor),
            changeTitleButton.topAnchor.constraint(equalTo: separator2.bottomAnchor),
            changeTitleButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            changeTitleButton.widthAnchor.constraint(equalToConstant: buttonWidth)
            ])
        
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
        viewFullScreen(content: selectedContent, from: self)
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

}
