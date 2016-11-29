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
    
    // Constraints
    var imageViewLeadingConstraint = NSLayoutConstraint()
    var imageViewTrailingConstraint = NSLayoutConstraint()
    var imageViewTopConstraint = NSLayoutConstraint()
    var imageViewBottomConstraint = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    
        self.view.addSubview(imageView)
        imageView.image = image
        
        navBarSetup()
        
        // ImageView setup
        
//        if image.size.width > self.view.bounds.size.width {
//            imageView.contentMode = .scaleAspectFit
//        } else {
//            imageView.contentMode = .center
//        }
        
        // ScrollView setup
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
//        scrollView.minimumZoomScale = 1.0
//        scrollView.maximumZoomScale = 6.0
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
    }
    
    func viewSetup() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageViewLeadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        imageViewTrailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        imageViewTopConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        imageViewBottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        //        imageViewLeadingConstraint = imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        //        imageViewTrailingConstraint = imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        //        imageViewTopConstraint = imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        //        imageViewBottomConstraint = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([imageViewLeadingConstraint, imageViewTrailingConstraint, imageViewTopConstraint, imageViewBottomConstraint])
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollViewLeadingConstraint = scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let scrollViewTrailingConstraint = scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let scrollViewTopConstraint = scrollView.topAnchor.constraint(equalTo: view.topAnchor)
        let scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([scrollViewLeadingConstraint, scrollViewTrailingConstraint, scrollViewTopConstraint, scrollViewBottomConstraint])
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()

        updateMinZoomScaleForSize(size: view.bounds.size)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: ScrollView Methods
    
    private func updateMinZoomScaleForSize(size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
    }
    
    private func updateConstraintsForSize(size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    // MARK: ScrollView Delegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(size: view.bounds.size)
    }
    
}
