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
    var student: Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetup()
    }
    
    func navBarSetup() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        navigationBar.frame = CGRect(x: 0, y: 0, width: size.width, height: 60)
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
        menu.popoverPresentationController?.sourceRect = cell.thumbnail.frame
        menu.modalPresentationStyle = .popover
        menu.preferredContentSize = CGSize(width: 200, height: 60)
        menu.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        menu.popoverPresentationController?.sourceView = cell
        
        let addContentButton = UIButton()
        addContentButton.titleLabel?.adjustsFontSizeToFitWidth = true
        if let studentName = student?.name {
          addContentButton.setTitle("Add to \(studentName)", for: .normal)
        }
        addContentButton.setTitleColor(UIColor.black, for: .normal)
        addContentButton.addTarget(self, action: #selector(addContentPressed), for: .touchUpInside)
        menu.view.addSubview(addContentButton)
        
        addContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let addContentHorizontalConstraint = addContentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let addContentVerticalConstraint = addContentButton.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor)
        
        NSLayoutConstraint.activate([addContentHorizontalConstraint, addContentVerticalConstraint])
        
        self.present(menu, animated: true, completion: nil)

    }
    
    func addContentPressed() {
        student?.addToContents(selectedContent!)
        let dataController = DataController.sharedInstance
        dataController.saveContext()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentAdded"), object: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }

}
