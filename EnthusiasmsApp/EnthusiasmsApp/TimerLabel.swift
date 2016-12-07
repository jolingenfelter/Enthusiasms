//
//  TimerView.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/5/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {
    
    var minutes: Int
    var seconds: Int
    
    override init(frame: CGRect) {
        self.minutes = 0
        self.seconds = 0
        super.init(frame: frame)
    }
    
    init(frame: CGRect, minutes: Int, seconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
        super.init(frame: frame)
        
        self.labelProperties()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.minutes = 0
        self.seconds = 0
        
        self.labelProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.minutes = 0
        self.seconds = 0
        super.init(coder: aDecoder)
    }
    
    func setRewardTime(minutes: Int, seconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
        
        formatTime()
    }
    
    private func labelProperties() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.textAlignment = .center
        formatTime()
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.font = self.font.withSize(24)
    }
    
    private func formatTime() {
        if seconds == 0 {
            self.text = "\(minutes):00"
        } else if seconds >= 1 && seconds < 10 {
            self.text = "\(minutes):0\(seconds)"
        } else {
            self.text = "\(minutes):\(seconds)"
        }
    }
}
