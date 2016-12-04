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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        youtubePlayerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        view.addSubview(youtubePlayerView)
        youtubePlayerView.loadVideoURL(videoURL!)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        youtubePlayerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
