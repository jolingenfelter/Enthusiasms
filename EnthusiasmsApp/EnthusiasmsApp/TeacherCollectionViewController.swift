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
        NotificationCenter.default.addObserver(self, selector: #selector(updateContents), name: NSNotification.Name(rawValue: "ContentAdded"), object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "NameUpdate"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ContentAdded"), object: nil)
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
        
        let addContentBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        
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
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
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
        let getContentView = GetWebContentViewController()
        getContentView.student = student
        self.present(getContentView, animated: true, completion: nil)
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
        cell.titleLabel.text = contentsArray[indexPath.item].title
    
        return cell
    }

    // MARK: UICollectionViewDelegate

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
