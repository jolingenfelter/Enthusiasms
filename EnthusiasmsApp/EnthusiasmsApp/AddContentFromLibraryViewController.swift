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
        
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = instructionsLabel.font.withSize(35)
        instructionsLabel.textAlignment = .center
        instructionsLabel.text = "Add content in 'All Content' or to a student."
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
        menu.preferredContentSize = CGSize(width: 200, height: 150)
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
        
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGray
        menu.view.addSubview(separator)
        
        let viewContentButton = UIButton()
        viewContentButton.setTitle("View", for: .normal)
        viewContentButton.setTitleColor(.black, for: .normal)
        viewContentButton.addTarget(self, action: #selector(viewContent), for: .touchUpInside)
        menu.view.addSubview(viewContentButton)
        
        let buttonHeight: CGFloat = 75
        let buttonWidth: CGFloat = 200
        
        addContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let addContentHorizontalConstraint = addContentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let addContentVerticalConstraint = addContentButton.bottomAnchor.constraint(equalTo: separator.topAnchor)
        let addContentHeightConstraint = addContentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let addContentWidthConstraint = addContentButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([addContentHorizontalConstraint, addContentVerticalConstraint, addContentHeightConstraint, addContentWidthConstraint])
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorLeadingConstraint = separator.leadingAnchor.constraint(equalTo: menu.view.leadingAnchor)
        let separatorTrailingConstraint = separator.trailingAnchor.constraint(equalTo: menu.view.trailingAnchor)
        let separatorHeightConstraint = separator.heightAnchor.constraint(equalToConstant: 1)
        let separatorVerticalConstraint = separator.centerYAnchor.constraint(equalTo: menu.view.centerYAnchor)
        
        NSLayoutConstraint.activate([separatorLeadingConstraint, separatorTrailingConstraint, separatorHeightConstraint, separatorVerticalConstraint])
        
        viewContentButton.translatesAutoresizingMaskIntoConstraints = false
        
        let viewContentHorizontalConstraint = viewContentButton.centerXAnchor.constraint(equalTo: menu.view.centerXAnchor)
        let viewContentVerticalConstraint = viewContentButton.topAnchor.constraint(equalTo: separator.bottomAnchor)
        let viewContentHeightConstraint = viewContentButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        let viewContentWidthConstraint = viewContentButton.widthAnchor.constraint(equalToConstant: buttonWidth)
        
        NSLayoutConstraint.activate([viewContentHorizontalConstraint, viewContentVerticalConstraint, viewContentHeightConstraint, viewContentWidthConstraint])
        
        self.present(menu, animated: true, completion: nil)

    }
    
    func addContentPressed() {
        student?.addToContents(selectedContent!)
        let dataController = DataController.sharedInstance
        dataController.saveContext()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentUpdate"), object: nil)
        self.presentedViewController?.dismiss(animated: true, completion: nil)
    }

}
