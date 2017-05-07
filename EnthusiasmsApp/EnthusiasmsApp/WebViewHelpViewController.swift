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
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 40)
            ])
        
        // TitleLabel Constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 15)
            ])
        
        // PicturesLabel Constraints
        picturesLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            picturesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            picturesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15)
            ])
        
        // PicturesDescriptionConstraints
        picturesDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            picturesDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            picturesDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            picturesDescription.topAnchor.constraint(equalTo: picturesLabel.bottomAnchor)
            ])
        
        // VideoLabel Constraints
        videoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            videoLabel.topAnchor.constraint(equalTo: picturesDescription.bottomAnchor, constant: 30)
            ])
        
        // VideoDescription Constraints
        videoDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            videoDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            videoDescription.topAnchor.constraint(equalTo: videoLabel.bottomAnchor),
            videoDescription.heightAnchor.constraint(equalToConstant: 120)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
