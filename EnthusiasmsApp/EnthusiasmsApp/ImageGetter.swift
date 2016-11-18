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

class ImageGetter: NSObject {

    let content: Content
    
    init(content: Content) {
        self.content = content
    }
    
    func getDataFromURL(completion: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        guard let contentURLString = self.content.url else {
            print("No contentURL")
            return
        }
        
        URLSession.shared.dataTask(with: URL(string: contentURLString)!) {
            (data, response, error) in completion(data, response, error)
        }.resume()
    }
    
    func downloadAndSaveImage() {
        print("Download Started")
        getDataFromURL { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            print("Download Finished")
            DispatchQueue.main.async {
                
                guard let contentIdentifier = self.content.uniqueFileName else {
                    return
                }
                
                if let image = UIImage(data: data) {
                    if let JPEGImageData = UIImageJPEGRepresentation(image, 0.8) {
                        let fileName = getDocumentsDirectory().appendingPathComponent("\(contentIdentifier).jpeg")
                        try? JPEGImageData.write(to: fileName)
                    }
                }
            }
        }
    }
    
    func getImage() -> UIImage? {
        
        var image = UIImage()
        
        if let contentIdentifier = self.content.uniqueFileName {
           
            let filePath = getDocumentsDirectory().appendingPathComponent("\(contentIdentifier).jpeg").path
            
            if FileManager.default.fileExists(atPath: filePath) {
                image = UIImage(contentsOfFile: filePath)!
            } else {
                print("No UUID")
            }
        }
        
        return image
        
    }
    
}
