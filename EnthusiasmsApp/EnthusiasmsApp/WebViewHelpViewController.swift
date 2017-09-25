//
//  WebViewHelpViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 1/4/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class WebViewHelpViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.text = "How do I save content?"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        self.view.addSubview(label)
        label.textColor = .white
        
        return label
        
    }()
    
    lazy var picturesLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Pictures:"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(label)
        label.textColor = .white
        
        return label
    
    }()
    
    lazy var picturesDescription: UILabel = {
        
        let label = UILabel()
        label.text = "To save an image, navigate to the page with the image.  Then, tap and hold on the image.  A popup will appear allowing you to give it a title and save.  Note, images are downloaded and saved on your device."
        label.numberOfLines = 0
        label.font = label.font.withSize(14)
        label.textColor = .white
        self.view.addSubview(label)
        
        
        return label
        
    }()
    
    lazy var videoLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Videos:"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        self.view.addSubview(label)
        
        return label
        
    }()
    
    lazy var videoDescription: UILabel = {
        
        let label = UILabel()
        label.text = "Currently, Enthusiasms only supports Youtube videos.  To save a video, in this browser, navigate to Youtube and then to the page of the video.  Next, tap and hold on the video.  A popup will appear allowing you to give it a title and save.  Please note, that Enthusiasms does not currently download videos.  Thus, video content will not be available offline."
        label.numberOfLines = 0
        label.font = label.font.withSize(14)
        label.textColor = .white
        self.view.addSubview(label)

        
        return label
        
    }()
    
    let navigationBar = UINavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =  UIColor(red: 0/255, green: 216/255, blue: 193/255, alpha: 1.0)

        // NavigationBar setup
        let navigationItem = UINavigationItem()
        navigationBar.items = [navigationItem]
        let cancelButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closePressed))
        navigationItem.leftBarButtonItem = cancelButton
        self.view.addSubview(navigationBar)
        
        self.view.addSubview(videoDescription)
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
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
            picturesDescription.topAnchor.constraint(equalTo: picturesLabel.bottomAnchor, constant: 5)
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
            videoDescription.topAnchor.constraint(equalTo: videoLabel.bottomAnchor, constant: 5)
            ])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
