//
//  TimeDisplay.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/31/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation

class TimeDisplay {
    
    var totalTimeInSeconds: Int
    
    private var minutes: Int {
        return totalTimeInSeconds / 60
        
    }
    
    private var seconds: Int {
        return totalTimeInSeconds % 60
    }
    
    var display: String {
        
        if seconds == 0 {
            return "\(minutes):00"
        } else if seconds >= 1 && seconds < 10 {
            return "\(minutes):0\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
        
    }
    
    init(timeInSeconds: Int) {
        self.totalTimeInSeconds = timeInSeconds
    }
    
}
