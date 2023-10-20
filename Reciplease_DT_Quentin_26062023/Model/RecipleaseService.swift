//
//  RecipleaseService.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import Foundation

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
    
    struct HitResponse: Decodable {
        let recipe: Recipe
    }
    
    let hits: [HitResponse]
}

class RecipiesService {
    private let ApiURL: String = "https://api.edamam.com/api/recipes/v2"

    private var session: URLSession
        
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getRecipes(foods: String, callBack: @escaping (Bool, RecipeResponse?) -> Void) {
        let key = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_KEY") as! String
        
        let id = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_ID") as! String
        
        var urlComponents = URLComponents(string: ApiURL)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: foods),
            URLQueryItem(name: "type", value: "public"),
            URLQueryItem(name: "app_id", value: id),
            URLQueryItem(name: "app_key", value: key)
        ]
        
        let url = urlComponents.url!

        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print("Error: \(error)")
                callBack(false, nil)
                return
            }
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    // API request was successful
                    if let data = data {
                        do {
                            let recipiesData = try JSONDecoder().decode(RecipeResponse.self, from: data)
                            callBack(true, recipiesData)
                            return
                            
                        } catch {
                            callBack(false, nil)
                            return
                        }
                    }
                } else {
                    // API request failed
                    callBack(false, nil)
                    return
                }
            }
        }
        task.resume()
    }
}
