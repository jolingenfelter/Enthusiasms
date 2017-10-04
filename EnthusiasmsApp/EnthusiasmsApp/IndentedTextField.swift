//
//  IndentedTextField.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/21/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class IndentedTextField: UITextField {

    init(placeHolder: String?, isSecureEntry: Bool, tag: Int?) {
        
        super.init(frame: CGRect.zero)
        
        // Indent
        let textInset = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        self.leftView = textInset
        self.leftViewMode = UITextFieldViewMode.always
        
        // BackgroundColor
        self.backgroundColor = .white
        
        // Corner Rounding
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        // PlaceHolder
        self.placeholder = placeHolder
        
        // SecureEntry
        self.isSecureTextEntry = isSecureEntry
        
        // Tag
        if let tag = tag {
            self.tag = tag
        }
        
        // AutoCorrection
        self.autocorrectionType = .no
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

