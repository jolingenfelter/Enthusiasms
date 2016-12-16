//
//  VideoThumnail.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 12/3/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import Foundation

enum ThumbnailQuailty : String {
    case Zero = "0.jpg"
    case One = "1.jpg"
    case Two = "2.jpg"
    case Three = "3.jpg"
    
    case Default = "default.jpg"
    case Medium = "mqdefault.jpg"
    case High = "hqdefault.jpg"
    case Standard = "sddefault.jpg"
    case Max = "maxresdefault.jpg"
    
    static let allValues = [Default, One, Two, Three,  Medium, High, Zero, Standard, High]
}

func thumbnailURLString(videoID:String, quailty: ThumbnailQuailty = .Default) -> String {
    
    return "http://i1.ytimg.com/vi/\(videoID)/\(quailty.rawValue)"
}
