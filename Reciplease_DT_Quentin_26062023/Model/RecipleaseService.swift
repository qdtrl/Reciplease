//
//  RecipleaseService.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import Foundation
import Alamofire

struct RecipeResponse: Decodable {
    struct Recipe: Decodable {
        let label: String
        let image: String
        let ingredientLines: [String]
        let totalTime: Double
        let url: String
        let yield: Double
        let dietLabels: [String]
        let healthLabels: [String]
        let mealType: [String]
    }
    
    struct Links: Decodable {
        let next: Next
    }
    
    struct Next: Decodable {
        let href: String
    }
    
    struct HitResponse: Decodable {
        let recipe: Recipe
    }
    let _links: Links
    let hits: [HitResponse]
}

class RecipiesService {
    private let apiURL: String = "https://api.edamam.com/api/recipes/v2"

    func getRecipes(foods: String, callBack: @escaping (Result<RecipeResponse, Error>) -> Void) {
         guard let key = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_KEY") as? String,
               let id = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_ID") as? String else {
             callBack(.failure(NSError(domain: "Missing API credentials", code: 401, userInfo: nil)))
             return
         }

         let parameters = [
             "q": foods,
             "type": "public",
             "app_id": id,
             "app_key": key,
         ]

        AF.request(apiURL, method: .get, parameters: parameters)
            .validate()
            .responseDecodable(of: RecipeResponse.self) { response in
            switch response.result {
            case .success(let recipeResponse):
                callBack(.success(recipeResponse))
            case .failure(let error):
                callBack(.failure(error))
            }
         }
     }
    
    func getNextRecipies(url: String, callBack: @escaping (Result<RecipeResponse, Error>) -> Void) {
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: RecipeResponse.self) { response in
            switch response.result {
            case .success(let recipeResponse):
                callBack(.success(recipeResponse))
            case .failure(let error):
                callBack(.failure(error))
            }
         }
    }
}
