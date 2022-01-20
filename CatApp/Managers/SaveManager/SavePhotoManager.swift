//
//  SavePhotoManager.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 20/01/2022.
//

import Foundation
import UIKit

final class SavePhotoManager {
    static let shared = SavePhotoManager()
    
    private init(){}
    
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        
        return nil
    }
    
    func saveToMemory(imageName: String?, keyType: Key) {
        guard let imageName = imageName else {
            return
        }
        
        var imageArray = [Image]()
        if let resultArray =  UserDefaults.standard.value([Image].self, forKey: keyType.rawValue) {
            imageArray = resultArray
            imageArray.append(.init(imageName: imageName))
            UserDefaults.standard.set(encodable: imageArray, forKey: keyType.rawValue)
        } else {
            imageArray.append(.init(imageName: imageName))
            UserDefaults.standard.set(encodable: imageArray, forKey: keyType.rawValue)
        }
    }
    
    func loadFromMemory(keyType: Key) -> [Image] {
        if let resultArray =  UserDefaults.standard.value([Image].self, forKey: keyType.rawValue) {
            return resultArray
        }
        
        return .init()
    }
}

extension SavePhotoManager {
    enum Key: String {
        case favoriteKey = "favorite"
        case downloadKey = "download"
    }
}
