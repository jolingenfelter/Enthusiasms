//
//  AddTimeButton.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimeButton: UIButton {
    
    var rewardTime: Int

    required init?(coder aDecoder: NSCoder) {
        self.rewardTime = 0
        super.init(coder: aDecoder)
    }
    
    init(type: UIButtonType = UIButtonType.custom, rewardTime: Int = 0) {
        self.rewardTime = rewardTime
        super.init(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        self.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
        self.setTitleColor(.black, for: .normal)
    }
    
    func addTimePressed() {
        
    }
}
