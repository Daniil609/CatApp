//
//  ViewControllerVM.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//

import Foundation
import UIKit

enum NotificationName: String{
        case load = "finishLoaded"
        case addToFavorite = "addToFavorites"
    }

final class AllPhotosVM {
    //MARK: - Internal Properties
    var dataModel = [DataModel]()
    var loadedPages: Int = 0
    var onStateChange: ((State) -> Void)?
}

extension AllPhotosVM {
    enum State {
        case dateSetup(Bool)
        case loadongState(Bool)
    }
}

extension AllPhotosVM {
    //MARK: - Public methods
    func launch() {
        onStateChange?(.loadongState(true))
        APICaller.shared.getPhotos(pageNumber: loadedPages) {[weak self] result in
            guard let self = self else {
                return
            }
            
            self.onStateChange?(.loadongState(false))
          
            switch result {
            case .success(let model):
                for element in model {
                    self.dataModel.append(element)
                }
                self.onStateChange?(.dateSetup(true))
                self.loadedPages += 1
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func pressSaveButton(imageURL: URL) {
        APICaller.shared.loadImage(url: imageURL) {[weak self] result in
            guard let self = self else{
                return
            }
            
           
            switch result {
            case .success(let image):
                let imageName = SavePhotoManager.shared.saveImage(image: image)
                SavePhotoManager.shared.saveToMemory(imageName: imageName, keyType: .downloadKey)
                self.loadimage()
                
            case .failure(_):
                break
            }
        }
    }
    
    func presAddToFavorite(imageURL: URL) {
        APICaller.shared.loadImage(url: imageURL) {[weak self] result in
            guard let self = self else{
                return
            }
            
            switch result {
            case .success(let image):
                let imageName = SavePhotoManager.shared.saveImage(image: image)
                SavePhotoManager.shared.saveToMemory(imageName: imageName, keyType: .favoriteKey)
                SavePhotoManager.shared.saveToMemory(imageName: imageName, keyType: .downloadKey)
                self.imageAddToFavorite()
                
            case .failure(_):
                break
            }
        }
    }
    
    func imageAddToFavorite() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.addToFavorite.rawValue), object: nil)
        }
    }
    
    func loadimage() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(NotificationName.load.rawValue), object: nil)
        }
    }
}
