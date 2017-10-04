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
    
    var content: Content
    let youtubePlayerView = YouTubePlayerView()
    var videoURL: URL?

    // Timer Variables
    var rewardTime = 0
    var remainingRewardTime = 0
    var timer = Timer()
    var addTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
    let addTimePasswordCheck = AddTimePasswordCheckViewController()
    let addTimeViewController = AddTimeViewController()
    let rightCoverView = UIView()
    let leftCoverView = UIView()
    
    lazy var timeDisplay: TimeDisplay = {
        
        let timeDisplay = TimeDisplay(timeInSeconds: self.rewardTime)
        return timeDisplay
        
    }()
    
    init(content: Content) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        rewardTime = appDelegate.rewardTime
        
        guard let urlString = content.url, let url = URL(string: urlString) else {
            return
        }
        
        videoURL = url
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
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
        
        // CoverViews
        view.addSubview(rightCoverView)
        view.addSubview(leftCoverView)
        
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
        
        super.viewDidLayoutSubviews()
        
        // PlayerView
        youtubePlayerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            youtubePlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            youtubePlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            youtubePlayerView.topAnchor.constraint(equalTo: view.topAnchor),
            youtubePlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        // Right CoverView
        rightCoverView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rightCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            rightCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightCoverView.widthAnchor.constraint(equalToConstant: 100),
            rightCoverView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        // Left CoverView
        leftCoverView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -45),
            leftCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftCoverView.widthAnchor.constraint(equalToConstant: 100),
            leftCoverView.heightAnchor.constraint(equalToConstant: 100)
            ])

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "cancelRequest"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTimePressed() {
        remainingRewardTime = rewardTime
        addTimePasswordCheck.modalPresentationStyle = .formSheet
        
        self.present(addTimePasswordCheck, animated: true, completion: nil)
    }

    @objc func donePressed() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime
        timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Timer
    
    @objc func updateTimer() {
        
        rewardTime -= 1
        timeDisplay.totalTimeInSeconds = rewardTime
        addTimeButton.setTitle(timeDisplay.display, for: .normal)
        let enterPasswordVC = EnterPasswordViewController()
        
        if rewardTime == 0 {
            
            timer.invalidate()
            
            self.present(enterPasswordVC, animated: true, completion: nil)
          
        }
        
    }
    
    @objc func addTimePasswordCheckComplete() {
        addTimeViewController.rewardTime = rewardTime
        addTimeViewController.modalPresentationStyle = .formSheet
        self.present(addTimeViewController, animated: true, completion: nil)
    }
    
    @objc func updateRewardTime() {
        rewardTime = addTimeViewController.updatedTime
    }

}
