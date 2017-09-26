//
//  UIViewControllerExtension.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(withTitle title: String, andMessage message: String, dismissSelf: Bool) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okToStay = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let okToDismiss = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        if dismissSelf {
            alert.addAction(okToDismiss)
        } else {
            alert.addAction(okToStay)
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func viewFullScreen(content: Content) {

        
        if content.type == ContentType.Image.rawValue {
            
            let imageViewer = FullScreenImageViewController(content: content)
            let navigationController = UINavigationController(rootViewController: imageViewer)
            present(navigationController, animated: true, completion: nil)
            
        } else {
           
            let videoViewer = FullScreenVideoViewController(content: content)
            let navigationController = UINavigationController(rootViewController: videoViewer)
            present(navigationController, animated: true, completion: nil)
            
        }
        
    }
    
}

