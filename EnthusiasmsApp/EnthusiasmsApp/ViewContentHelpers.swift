//
//  ViewContentHelpers.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

func imageViewer(for content: Content) -> FullScreenImageViewController? {
    let imageViewer = FullScreenImageViewController()
    imageViewer.content = content
    
    guard let imageFileName = content.uniqueFileName, let imageURL = content.url else {
        return nil
    }
    
    let imageGetter = ImageGetter(imageName: imageFileName, imageURL: URL(string: imageURL)!)
    
    guard let contentImage = imageGetter.getImage() else {
        return nil
    }
    
    imageViewer.image = contentImage
    
    return imageViewer
}

func videoPlayer(for content: Content) -> FullScreenVideoViewController? {
    let videoPlayer = FullScreenVideoViewController()
    
    guard let videoURLString = content.url, let videoURL = URL(string: videoURLString) else {
        return nil
    }
    
    videoPlayer.videoURL = videoURL
    
    return videoPlayer
}
