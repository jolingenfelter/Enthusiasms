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
        self.text = "\(minutes):\(seconds)"
    }
    
    private func labelProperties() {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.textAlignment = .center
        self.text = "\(minutes):\(seconds)"
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.font = self.font.withSize(24)
    }
}
