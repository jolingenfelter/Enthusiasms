//
//  ImageGetter.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData


class ContentImageSaver: NSObject {
    
    let content: Content
    
    init(content: Content) {
        self.content = content
    }
    
    private func getDataFromURL(completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        if content.type == ContentType.Image.rawValue {
            
            guard let contentURL = self.content.url else {
                return
            }
            
            URLSession.shared.dataTask(with: URL(string:contentURL)!) {
                (data, response, error) in completion(data, response, error)
                }.resume()
            
        } else {
            
            guard let thumbnailURL = self.content.thumbnailURL else {
                return
            }
            
            URLSession.shared.dataTask(with: URL(string:thumbnailURL)!) {
                (data, response, error) in completion(data, response, error)
                }.resume()
            
        }

    }
    
    private func generateImageName() -> String {
        let uuid = UUID().uuidString
        return uuid
    }
    
    func downloadNameAndSaveImage() {
        
        getDataFromURL { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                
                if let image = UIImage(data: data) {
                    
                    if let JPEGImageData = UIImageJPEGRepresentation(image, 0.8) {
                        
                        self.content.uniqueFileName = self.generateImageName()
                        DataController.sharedInstance.saveContext()
                        
                        let fileName = getDocumentsDirectory().appendingPathComponent("\(self.content.uniqueFileName!).jpeg")
                        try? JPEGImageData.write(to: fileName)
                        
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ContentUpdate"), object: nil)
                    }
                }
            }
        }
    }
    
}

func getImage(imageName: String) -> UIImage? {
    
    var image = UIImage()
    
    let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).jpeg").path
    
    if FileManager.default.fileExists(atPath: filePath) {
        image = UIImage(contentsOfFile: filePath)!
    }
    
    return image
    
}
