//
//  ImageGetter.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

class ContentImageSaver: NSObject {
    
    let content: Content
    var imageName: String?
    let imageURL: URL
    
    init(content: Content, imageURL: URL) {
        self.content = content
        self.imageURL = imageURL
    }
    
    func getDataFromURL(completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        URLSession.shared.dataTask(with: self.imageURL) {
            (data, response, error) in completion(data, response, error)
        }.resume()
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
