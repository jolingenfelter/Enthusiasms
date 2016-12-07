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
    let timerLabel = TimerLabel()
    var rewardTime = 0
    
    var minutes: Int {
        return rewardTime / 60
    }
    var seconds: Int {
        return rewardTime % 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = student?.name
        
        // Timer Setup
        
        timerLabel.frame = CGRect(x: 400, y: 80, width: 80, height: 50)
        timerLabel.setRewardTime(minutes: minutes, seconds: rewardTime % 60)
        view.addSubview(timerLabel)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func navigationBarSetup() {
        let homeButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(StudentCollectionViewController.homePressed))
        self.navigationItem.rightBarButtonItem = homeButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedContent = contentsArray[indexPath.row]
        
        viewFullScreen(content: selectedContent, from: self, with: timerLabel)
        
    }
    
    override func homePressed() {
        let enterPasswordVC = EnterPasswordViewController()
        self.present(enterPasswordVC, animated: true, completion: nil)
    }
    
    func updateTimer() {
        if rewardTime > 0 {
            timerLabel.setRewardTime(minutes: minutes, seconds: seconds)
            rewardTime -= 1
            
        } else if rewardTime == 0 {
            timerLabel.setRewardTime(minutes: minutes, seconds: seconds)
            timer.invalidate()
        }
        
    }
    
}
