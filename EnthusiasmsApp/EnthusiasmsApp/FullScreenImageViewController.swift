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
    let imageScrollView = ImageScrollView()
    
    // Timer Variables
    var rewardTime = 0
    var remainingRewardTime = 0
    var timer = Timer()
    var addTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
    let addTimePasswordCheck = AddTimePasswordCheckViewController()
    let addTimeViewController = AddTimeViewController()

    
    lazy var timeDisplay: TimeDisplay = {
        
        let timeDisplay = TimeDisplay(timeInSeconds: self.rewardTime)
        return timeDisplay
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
         viewSetup()
        
        // Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(updateRewardTime), name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addTimePasswordCheckComplete), name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }
    
    func navBarSetup() {
        
        navigationController?.hidesBarsOnTap = true
        
        self.title = content?.title
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        self.navigationItem.rightBarButtonItem = doneButton
        if rewardTime > 0 {
            addTimeButton.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
            addTimeButton.setTitleColor(.black, for: .normal)
            let addTimeBarButton = UIBarButtonItem.init(customView: addTimeButton)
            self.navigationItem.leftBarButtonItem = addTimeBarButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navBarSetup()
    }
    
    func viewSetup() {
        
        DispatchQueue.main.async {
            self.imageScrollView.displayImage(self.image)
        }
        
        view.addSubview(imageScrollView)
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
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
    
    // MARK: Timer
    
    func updateTimer() {
        
        rewardTime -= 1
        timeDisplay.totalTimeInSeconds = rewardTime
        addTimeButton.setTitle(timeDisplay.display, for: .normal)
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
