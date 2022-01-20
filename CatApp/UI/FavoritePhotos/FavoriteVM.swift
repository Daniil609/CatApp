//
//  FavoriteViewControllerVM.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 20/01/2022.
//

import Foundation
import UIKit

public class FavoriteVM {
    //MARK: - Internal properties
    var favoritePhotos = [UIImage]()
    var onStateChange: ((State) -> Void)?
}

extension FavoriteVM {
    enum State {
        case dateSetup(Bool)
    }
}

extension FavoriteVM {
    //MARK: - Public methods
    func launch() {
        favoritePhotos.removeAll()
        let photos = SavePhotoManager.shared.loadFromMemory(keyType: .favoriteKey)
        if photos.count == 0 {
            onStateChange?(.dateSetup(false))
        }
        
        for element in photos {
            if let imageName = element.imageName {
                favoritePhotos.append(SavePhotoManager.shared.loadImage(fileName: imageName)!)
            }
        }
        
        onStateChange?(.dateSetup(true))
    }
}
