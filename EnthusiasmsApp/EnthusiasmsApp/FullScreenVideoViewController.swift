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

    // Timer Variables
    var rewardTime = 0
    var remainingRewardTime = 0
    var timer = Timer()
    var addTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
    let addTimePasswordCheck = AddTimePasswordCheckViewController()
    let addTimeViewController = AddTimeViewController()
    let coverView = UIView()
    
    var minutes: Int {
        return rewardTime / 60
    }
    var seconds: Int {
        return rewardTime % 60
    }
    var timeDisplay: String {
        if seconds == 0 {
            return "\(minutes):00"
        } else if seconds >= 1 && seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        view.addSubview(youtubePlayerView)
        youtubePlayerView.playerVars = ["showinfo": 0 as AnyObject, "rel": 0 as AnyObject]
        youtubePlayerView.loadVideoURL(videoURL!)
        navBarSetup()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(updateRewardTime), name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addTimePasswordCheckComplete), name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
        
        // CoverView
        view.addSubview(coverView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Initial Timer Setup
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }
    
    func navBarSetup() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        if rewardTime > 0 {
            addTimeButton.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
            addTimeButton.setTitleColor(.black, for: .normal)
            let addTimeBarButton = UIBarButtonItem.init(customView: addTimeButton)
            self.navigationItem.leftBarButtonItem = addTimeBarButton
        }
    }
    
    override func viewDidLayoutSubviews() {
        youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        let playerLeadingConstraint = youtubePlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let playerTrailingConstraint = youtubePlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let playerTopConstraint = youtubePlayerView.topAnchor.constraint(equalTo: view.topAnchor)
        let playerBottomConstraint = youtubePlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([playerLeadingConstraint, playerTrailingConstraint, playerTopConstraint, playerBottomConstraint])
        
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        let coverViewVerticalConstraint = coverView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let coverViewHorizontalConstraint = coverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let coverViewWidthConstraint = coverView.widthAnchor.constraint(equalToConstant: 100)
        let coverViewHeightConstraint = coverView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([coverViewVerticalConstraint, coverViewHorizontalConstraint, coverViewWidthConstraint, coverViewHeightConstraint])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTimePressed() {
        remainingRewardTime = rewardTime
        addTimePasswordCheck.modalPresentationStyle = .formSheet
        
        self.present(addTimePasswordCheck, animated: true, completion: nil)
    }

    func donePressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Timer
    
    func updateTimer() {
        
        rewardTime -= 1
        addTimeButton.setTitle(timeDisplay, for: .normal)
        let enterPasswordVC = EnterPasswordViewController()
        
        if rewardTime == 0 {
            
            timer.invalidate()
            
            self.present(enterPasswordVC, animated: true, completion: nil)
          
        }
        
    }
    
    func addTimePasswordCheckComplete() {
        addTimeViewController.rewardTime = rewardTime
        addTimeViewController.modalPresentationStyle = .formSheet
        self.present(addTimeViewController, animated: true, completion: nil)
    }
    
    func updateRewardTime() {
        rewardTime = addTimeViewController.updatedTime
    }

}
