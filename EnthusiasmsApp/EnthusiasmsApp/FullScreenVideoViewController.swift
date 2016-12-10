//
//  FullScreenVideoViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import YouTubePlayer

class FullScreenVideoViewController: UIViewController {
    
    let youtubePlayerView = YouTubePlayerView()
    var videoURL: URL?
    var rewardTime: Int?
    var addTimeButton: AddTimeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(youtubePlayerView)
        youtubePlayerView.loadVideoURL(videoURL!)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: addTimeButton!)
        
    }
    
    override func viewDidLayoutSubviews() {
        youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        let playerLeadingConstraint = youtubePlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let playerTrailingConstraint = youtubePlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let playerTopConstraint = youtubePlayerView.topAnchor.constraint(equalTo: view.topAnchor)
        let playerBottomConstraint = youtubePlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([playerLeadingConstraint, playerTrailingConstraint, playerTopConstraint, playerBottomConstraint])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
