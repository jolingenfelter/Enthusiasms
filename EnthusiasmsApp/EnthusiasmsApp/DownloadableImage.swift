//
//  DownloadableImage.swift
//  EnthusiasmsApp
//
//  Created by Joanna LINGENFELTER on 10/4/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import CoreData
import UIKit

protocol DownloadableImage {
    var imageGetter: ImageGetter { get }
    var dataController: DataController { get }
}

extension DownloadableImage {
    
    func getImageURL(forContent content: Content) -> URL? {
        
        guard let contentType = ContentType(rawValue: content.type) else {
            return nil
        }
        
        switch contentType {
        case .Image:
            
            guard let urlString = content.url, let url = URL(string: urlString) else {
                return nil
            }
            
            return url
            
        case .Video:
            
            guard let urlString = content.thumbnailURL, let url = URL(string: urlString) else {
                return nil
            }
            
            return url
            
        }
    }
    
    func saveImageFrom(url: URL, forContent content: Content) {
        
        imageGetter.getImage(from: url, completion: { (result) in
            
            switch result {
            case .ok(let image):
                
                if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                    
                    content.uniqueFileName = generateImageName()
                    
                    let fileName = getDocumentsDirectory().appendingPathComponent("\(content.uniqueFileName!).jpeg")
                    
                    do {
                        
                        try imageData.write(to: fileName)
                        self.dataController.saveContext()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ContentUpdate"), object: nil)
                        
                    } catch let error {
                        self.dataController.managedObjectContext.delete(content)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorSavingImage"), object: nil, userInfo: ["message" : "There was an error saving the image: \(error.localizedDescription)"])
                    }
                }
                
            case .error(let error):
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ErrorDownloadingImage"), object: nil, userInfo: ["message" : "There was an error downloading the image: \(error.localizedDescription)"])
            }
        })
        
    }
}
