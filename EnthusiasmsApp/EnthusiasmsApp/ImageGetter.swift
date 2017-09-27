//
//  ImageGetter.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 11/17/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

import UIKit
import CoreData


class ContentImageSaver {
    
    let content: Content
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }()
    
    private var url: URL? {
        
        var urlString = String()
        
        if content.type == ContentType.Image.rawValue {
            
            guard let string = content.url else {
                return nil
            }
            
            urlString = string
            
        } else if content.type == ContentType.Video.rawValue {
            
            guard let string = content.thumbnailURL else {
                return nil
            }
            
            urlString = string
        }
        
        return URL(string: urlString)
    }
    
    init(content: Content) {
        self.content = content
    }
    
    private func getDataFromURL(completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        guard let url = url else {
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            completion(data, response, error)
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
