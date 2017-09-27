//
//  Utilities.swift
//  EnthusiasmsApp
//
//  Created by Joanna Lingenfelter on 5/14/17.
//  Copyright © 2017 JoLingenfelter. All rights reserved.
//

import UIKit

func getDocumentsDirectory() -> URL {
    
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    
    return documentsDirectory
}

func deleteFile(named: String) {
    
    let filePath = getDocumentsDirectory().appendingPathComponent("\(named).jpeg").path
    
    
    if FileManager.default.fileExists(atPath: filePath) {
        
        do {
            
            try FileManager.default.removeItem(atPath: filePath)
            
        } catch let error {
            
            print(error.localizedDescription)
            
        }
        
    }
    
}

func getImage(imageName: String) -> UIImage? {
    
    let filePath = getDocumentsDirectory().appendingPathComponent("\(imageName).jpeg").path
    
    if FileManager.default.fileExists(atPath: filePath) {
        
        guard let image = UIImage(contentsOfFile: filePath) else {
            return nil
        }
        
        return image
    }
    
    return nil
    
}
