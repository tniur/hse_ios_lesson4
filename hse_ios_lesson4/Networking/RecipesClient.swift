//
//  RecipesClient.swift
//  hse_ios_lesson4
//
//  Created by Pavel Bobkov on 03.11.2024.
//

import UIKit
import Alamofire

enum Headers: String {
    case key = "7ca12cc3b1mshd16f11060f69f34p1d299cjsnb8c2c2ff309b"
    case host = "chinese-food-db.p.rapidapi.com"
}

protocol RecipesClientProtocol {
    func fetchRecipes(completion: @escaping (Result<[RecipeModel], Error>) -> Void)
    func fetchRecipeDetailsById(id: String, completion: @escaping (Result<RecipeDetailsModel, Error>) -> Void)
    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class RecipesClient: RecipesClientProtocol {
    
    // MARK: - Init
    
    static let shared = RecipesClient()
    private init() {}
    
    // MARK: - Methods
    
    func fetchRecipes(completion: @escaping (Result<[RecipeModel], Error>) -> Void) {
        let headers: HTTPHeaders = [
            "x-rapidapi-key": Headers.key.rawValue,
            "x-rapidapi-host": Headers.host.rawValue
        ]
        
        let url = "https://chinese-food-db.p.rapidapi.com/"
        
        AF.request(url, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        guard let data else { return }
                        let recipes = try JSONDecoder().decode([RecipeModel].self, from: data)
                        completion(.success(recipes))
                    } catch let decodingError {
                        print("Failed to decode JSON:", decodingError)
                        completion(.failure(decodingError))
                    }
                case .failure(let error):
                    print("Request failed:", error)
                    completion(.failure(error))
                }
            }
    }
    
    func fetchRecipeDetailsById(id: String, completion: @escaping (Result<RecipeDetailsModel, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "x-rapidapi-key": Headers.key.rawValue,
            "x-rapidapi-host": Headers.host.rawValue
        ]
        
        let url = "https://chinese-food-db.p.rapidapi.com/\(id)"
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    do {
                        guard let data else { return }
                        let recipes = try JSONDecoder().decode(RecipeDetailsModel.self, from: data)
                        completion(.success(recipes))
                    } catch let decodingError {
                        print("Failed to decode JSON:", decodingError)
                        completion(.failure(decodingError))
                    }
                case .failure(let error):
                    print("Request failed:", error)
                    completion(.failure(error))
                }
            }
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    } else {
                        let error = NSError(domain: "ImageDecodingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to decode image"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
