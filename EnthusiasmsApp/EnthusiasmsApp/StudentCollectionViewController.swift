//
//  StudentCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class StudentCollectionViewController: TeacherCollectionViewController {
    
    var timer = Timer()
    var rewardTime = 0
    var remainingRewardTime = 0
    var updatedTime = 0
    var addTimeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
    let addTimeViewController = AddTimeViewController()
    let addTimePasswordCheck = AddTimePasswordCheckViewController()
    
    lazy var timeDisplay: TimeDisplay = {
        let timeDisplay = TimeDisplay(timeInSeconds: self.rewardTime)
        return timeDisplay
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = student.name
        
        // Timer Setup
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationBarSetup()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        rewardTime = appDelegate.rewardTime
        updateTimer()
        
        // Observers
        NotificationCenter.default.addObserver(self, selector: #selector(updateRewardTime), name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addTimePasswordCheckComplete), name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
        
        // Instructions Label
        instructionsLabel.text = "Sign in as a caretaker to add content"
        instructionsLabel.font = instructionsLabel.font.withSize(30)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "timeAdded"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "addTimePasswordCheck"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func navigationBarSetup() {
        
        let homeButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(StudentCollectionViewController.homePressed))
        
        navigationItem.rightBarButtonItem = homeButton
        
        addTimeButton.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
        addTimeButton.setTitleColor(.black, for: .normal)
        
        let addTimeBarButton = UIBarButtonItem.init(customView: addTimeButton)
        
        self.navigationItem.leftBarButtonItem = addTimeBarButton
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedContent = contentsArray[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rewardTime = rewardTime
        
        viewFullScreen(content: selectedContent)
        
    }
    
    @objc override func homePressed() {
        
        let alert = UIAlertController(title: "Quit?", message: "Are you sure you want to quit?", preferredStyle: .alert)
        
        let quitAction = UIAlertAction(title: "Quit", style: .destructive) { (action) in
            
            self.timer.invalidate()
            let enterPasswordVC = EnterPasswordViewController()
            self.present(enterPasswordVC, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(quitAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

    }
    
    // MARK: Timer
    
    @objc func updateTimer() {
        
        rewardTime -= 1
        timeDisplay.totalTimeInSeconds = rewardTime
        addTimeButton.setTitle(timeDisplay.display, for: .normal)
        let enterPasswordVC = EnterPasswordViewController()
        
        if rewardTime == 0 {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.rewardTime = 0
            
            timer.invalidate()
            
            self.present(enterPasswordVC, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func addTimePressed() {

        remainingRewardTime = rewardTime
        addTimePasswordCheck.modalPresentationStyle = .formSheet
        
        self.present(addTimePasswordCheck, animated: true, completion: nil)
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
