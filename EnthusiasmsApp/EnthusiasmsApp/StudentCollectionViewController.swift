//
//  StudentCollectionViewController.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 9/20/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class StudentCollectionViewController: TeacherCollectionViewController {
    
    var timer = Timer()
    var rewardTime = 0
    var addTimeButton = AddTimeButton()
    
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

        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = student?.name
        
        // Timer Setup
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       navigationBarSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func navigationBarSetup() {
        let homeButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(StudentCollectionViewController.homePressed))
        self.navigationItem.rightBarButtonItem = homeButton
        let addTimeBarButton = UIBarButtonItem.init(customView: addTimeButton)
        self.navigationItem.leftBarButtonItem = addTimeBarButton
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedContent = contentsArray[indexPath.row]
        
        viewFullScreen(content: selectedContent, from: self, with: addTimeButton)
        
    }
    
    override func homePressed() {
        let enterPasswordVC = EnterPasswordViewController()
        self.present(enterPasswordVC, animated: true, completion: nil)
    }
    
    func updateTimer() {
        if rewardTime > 0 {
            addTimeButton.setTitle(timeDisplay, for: .normal)
            addTimeButton.rewardTime = rewardTime
            rewardTime -= 1
            
        } else if rewardTime == 0 {
            addTimeButton.setTitle(timeDisplay, for: .normal)
            addTimeButton.rewardTime = rewardTime
            timer.invalidate()
        }
        
    }
    
}
