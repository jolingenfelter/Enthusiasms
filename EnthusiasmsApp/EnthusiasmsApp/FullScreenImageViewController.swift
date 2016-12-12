//
//  FullScreenImageViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/27/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    var content: Content?
    var image = UIImage()
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    var rewardTime: Int?
    var addTimeButton: UIButton?
    
    // Constraints
    var imageViewLeadingConstraint = NSLayoutConstraint()
    var imageViewTrailingConstraint = NSLayoutConstraint()
    var imageViewTopConstraint = NSLayoutConstraint()
    var imageViewBottomConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navBarSetup()
    
        view.addSubview(scrollView)
        self.view.addSubview(imageView)
        imageView.image = image
        
        // ImageView setup
        
        if image.size.width > self.view.bounds.size.width {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .center
        }
        
        // ScrollView setup
        
        scrollView.addSubview(imageView)
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
//        scrollView.showsVerticalScrollIndicator = true
//        scrollView.showsHorizontalScrollIndicator = true
//        scrollView.flashScrollIndicators()
        
         viewSetup()
    }
    
    func navBarSetup() {
        
        navigationController?.hidesBarsOnTap = true
        
        self.title = content?.title
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        if let addTimeButton = addTimeButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addTimeButton)
        }
    }
    
    func viewSetup() {
        
        // ImageView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([imageViewLeadingConstraint, imageViewTrailingConstraint, imageViewTopConstraint, imageViewBottomConstraint])
        
        // Scroll View
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewLeadingConstraint = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let scrollViewTrailingConstraint = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewLeadingConstraint, scrollViewTrailingConstraint, scrollViewTopConstraint, scrollViewBottomConstraint])
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: ScrollView Delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}
