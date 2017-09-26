//
//  ViewContentHelpers.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit

fileprivate func imageViewer(for content: Content) -> FullScreenImageViewController? {
    
    let imageViewer = FullScreenImageViewController()
    imageViewer.content = content
    
    guard let imageName = content.uniqueFileName else {
        return nil
    }
    
    guard let contentImage = getImage(imageName: imageName) else {
        return nil
    }
    
    imageViewer.image = contentImage
    
    return imageViewer
}

fileprivate func videoPlayer(for content: Content) -> FullScreenVideoViewController? {
    
    let videoPlayer = FullScreenVideoViewController()
    
    guard let videoURLString = content.url, let videoURL = URL(string: videoURLString) else {
        return nil
    }
    
    videoPlayer.videoURL = videoURL
    
    return videoPlayer
}

extension UIViewController {
    
    func viewFullScreen(content: Content) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if content.type == ContentType.Image.rawValue {
            
            guard let imageViewer = imageViewer(for: content) else {
                return
            }
            
            imageViewer.rewardTime = appDelegate.rewardTime
            let navigationController = UINavigationController(rootViewController: imageViewer)
            present(navigationController, animated: true, completion: nil)
            
        } else {
            guard let videoPlayer = videoPlayer(for: content) else {
                return
            }
            
            videoPlayer.rewardTime = appDelegate.rewardTime
            let navigationController = UINavigationController(rootViewController: videoPlayer)
            present(navigationController, animated: true, completion: nil)
            
        }
        
    }
    
}

