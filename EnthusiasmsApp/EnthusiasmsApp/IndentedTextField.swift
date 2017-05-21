//
//  IndentedTextField.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/21/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

class IndentedTextField {
    
    let textField = UITextField()

    init(placeHolder: String?, isSecureEntry: Bool, tag: Int?) {
        
        // Indent
        let textInset = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textField.leftView = textInset
        textField.leftViewMode = UITextFieldViewMode.always
        
        // BackgroundColor
        textField.backgroundColor = .white
        
        // Corner Rounding
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        // PlaceHolder
        textField.placeholder = placeHolder
        
        // SecureEntry
        textField.isSecureTextEntry = isSecureEntry
        
        // Tag
        if let tag = tag {
            textField.tag = tag
        }
        
        // AutoCorrection
        textField.autocorrectionType = .no
        
    }

}

