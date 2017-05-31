//
//  AddContentFromLibraryViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/21/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddContentFromLibraryViewController: AllContentCollectionViewController {
    
    var navigationBar = UINavigationBar()
    let student: Student
    
    lazy var fromLibraryMenu: AddContentFromLibraryMenu = {
        
        let menu = AddContentFromLibraryMenu(student: self.student)
        return menu
        
    }()
    
    init(student: Student, flowLayout: UICollectionViewFlowLayout) {
        self.student = student
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
        
        // Edit instructions label from AllContentVC super class
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = instructionsLabel.font.withSize(35)
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = "Add content in 'All Content' or to a student."
    }
    
    func navBarSetup() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedContent = fetchedResultsController.object(at: indexPath)
        showMenufor(cellAtIndexPath: indexPath)
    }
    
    override func showMenufor(cellAtIndexPath indexPath: IndexPath) {
        
        let cell = self.collectionView?.cellForItem(at: indexPath) as! ContentCollectionViewCell
        fromLibraryMenu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        fromLibraryMenu.modalPresentationStyle = .popover
        fromLibraryMenu.preferredContentSize = CGSize(width: 200, height: 150)
        fromLibraryMenu.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        fromLibraryMenu.popoverPresentationController?.sourceView = cell
        
        fromLibraryMenu.addContentButton.addTarget(self, action: #selector(addContentPressed), for: .touchUpInside)
        fromLibraryMenu.addContentButton.setTitle("Add Content to \(student.name!)", for: .normal)
        fromLibraryMenu.viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        
        self.present(fromLibraryMenu, animated: true, completion: nil)

    }
    
    func addContentPressed() {
        student.addToContents(selectedContent!)
        let dataController = DataController.sharedInstance
        dataController.saveContext()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentUpdate"), object: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }

}
