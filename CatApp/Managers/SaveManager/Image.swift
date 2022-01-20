//
//  Image.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 20/01/2022.
//

import Foundation

class Image: Codable {
    //MARK: - Internal properties
    var imageName:String?
    
    //MARK: - Init
    init(imageName:String) {
        self.imageName = imageName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.imageName, forKey: .imageName)
    }
}

private extension Image {
    enum CodingKeys: String, CodingKey {
        case imageName
    }
}
