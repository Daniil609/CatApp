//
//  APICaller.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//

import Foundation
import UIKit

final class APICaller {
    static let shared = APICaller()
    
    private init(){}
    
    public func getPhotos(pageNumber: Int, completion: @escaping (Result<[DataModel], Error>) -> Void){
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10&page=\(pageNumber)&order=Desc") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else{
                return
            }
            
            do{
                let result = try JSONDecoder().decode([DataModel].self, from: data)
                completion(.success(result))
            }
            catch{
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    func loadImage(url: URL,completion: @escaping (Result<UIImage, Error>) -> Void ) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion(.success(image))
                    
                }
            }
        }
    }

}

extension APICaller {
    enum HTTPMethod :String {
        case GET
        case POST
        case DELETE
        case PUT
    }
}
