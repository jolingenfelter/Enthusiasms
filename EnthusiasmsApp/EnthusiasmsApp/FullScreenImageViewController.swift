//
//  FullScreenImageViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/27/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    
    var image = UIImage()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.image = image
        
        navBarSetup()
    }
    
    func navBarSetup() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    override func viewDidLayoutSubviews() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let leadingConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingConstraint = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let topConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
