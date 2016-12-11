//
//  AddTimeButton.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/10/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

class AddTimeButton: UIButton {
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type: UIButtonType = UIButtonType.custom) {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        self.addTarget(self, action: #selector(addTimePressed), for: .touchUpInside)
        self.setTitleColor(.black, for: .normal)
    }
    
    func addTimePressed() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addTimePressed"), object: nil)
    }
}
