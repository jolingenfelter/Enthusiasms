//
//  WebViewHelpViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 1/4/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class WebViewHelpViewController: UIViewController {
    
    let titleLabel = UILabel()
    let picturesLabel = UILabel()
    let videoLabel = UILabel()
    let picturesDescription = UILabel()
    let videoDescription = UILabel()
    let navigationBar = UINavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        // NavigationBar setup
        let navigationItem = UINavigationItem()
        navigationBar.items = [navigationItem]
        let cancelButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed))
        navigationItem.leftBarButtonItem = cancelButton
        self.view.addSubview(navigationBar)
        
        // TitleLabel Setup
        titleLabel.text = "How do I save content?"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(titleLabel)
        
        // PicturesLabel
        picturesLabel.text = "Pictures:"
        picturesLabel.textAlignment = .center
        picturesLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(picturesLabel)
        
        // PicturesDescriptionLabel
        picturesDescription.text = "To save an image, navigate to the page with the image.  Then, tap and hold on the image.  A popup will appear allowing you to give the image a title and save."
        picturesDescription.numberOfLines = 0
        picturesDescription.font = picturesDescription.font.withSize(14)
        self.view.addSubview(picturesDescription)
        
        // VideoLabel
        videoLabel.text = "Videos:"
        videoLabel.textAlignment = .center
        videoLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(videoLabel)
        
        // VideoDescriptionLabel
        videoDescription.text = "Currently, Enthusiasms only supports Youtube videos.  To save a Youtube Video, navigate to the video on Youtube in this browser.  Once on the page of the video, tap the navigation bar.  A menu will pop up with the option to 'Save Video URL', select it and a popup will appear allowing you to give the video a title and save.  Please note, that Enthusiasms does not currently download videos and video content will not be available offline."
        videoDescription.numberOfLines = 0
        videoDescription.font = videoDescription.font.withSize(14)
        self.view.addSubview(videoDescription)
    }
    
    override func viewDidLayoutSubviews() {
        // NavigationBar Constraints
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        
        let navigationBarLeadingConstraint = navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let navigationBarTrailingConstraint = navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let navigationBarHeight = navigationBar.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([navigationBarLeadingConstraint, navigationBarTrailingConstraint, navigationBarHeight])
        
        // TitleLabel Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelHorizontalConstraint = titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let titleLabelVerticalConstraint = titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15)
        
        NSLayoutConstraint.activate([titleLabelHorizontalConstraint, titleLabelVerticalConstraint])
        
        // PicturesLabel Constraints
        picturesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let picturesLabelHorizontalConstraint = picturesLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        let picturesLabelVerticalConstraint = picturesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
        
        NSLayoutConstraint.activate([picturesLabelHorizontalConstraint, picturesLabelVerticalConstraint])
        
        // PicturesDescriptionConstraints
        picturesDescription.translatesAutoresizingMaskIntoConstraints = false
        
        let picturesDescriptionLeadingConstraint = picturesDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        let picturesDescriptionTrailingConstraint = picturesDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
        let picturesDescriptionVerticalConstraint = picturesDescription.topAnchor.constraint(equalTo: picturesLabel.bottomAnchor)
        let picturesDescriptionHeightConstraint = picturesLabel.heightAnchor.constraint(equalToConstant: 40)
        
        NSLayoutConstraint.activate([picturesDescriptionLeadingConstraint, picturesDescriptionTrailingConstraint, picturesDescriptionVerticalConstraint, picturesDescriptionHeightConstraint])
        
        // VideoLabel Constraints
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let videoLabelHorizontalConstraint = videoLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        let videoLabelVerticalConstraint = videoLabel.topAnchor.constraint(equalTo: picturesDescription.bottomAnchor, constant: 30)
        
        NSLayoutConstraint.activate([videoLabelHorizontalConstraint, videoLabelVerticalConstraint])
        
        // VideoDescription Constraints
        videoDescription.translatesAutoresizingMaskIntoConstraints = false
        
        let videoDescriptionLeadingConstraint = videoDescription.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15)
        let videoDescriptionTrailingConstraint = videoDescription.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15)
        let videoDescriptionVerticalConstraint = videoDescription.topAnchor.constraint(equalTo: videoLabel.bottomAnchor)
        let videoDescriptionHeightConstraint = videoDescription.heightAnchor.constraint(equalToConstant: 120)
        
        NSLayoutConstraint.activate([videoDescriptionHeightConstraint, videoDescriptionLeadingConstraint, videoDescriptionTrailingConstraint, videoDescriptionVerticalConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
