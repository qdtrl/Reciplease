//
//  RecipleaseService.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import Foundation

struct RecipeImages: Codable {
    let thumbnail: ImageData
    let small: ImageData
    let regular: ImageData
    let large: ImageData
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
        case large = "LARGE"
    }
}

struct ImageData: Codable {
    let url: String
    let width: Int
    let height: Int
}

struct Ingredient: Codable {
    let text: String
    let quantity: Int
    let measure: String
    let food: String
    let weight: Int
    let foodId: String
}

struct Digest: Codable {
    let label: String
    let tag: String
    let schemaOrgTag: String
    let total: Int
    let hasRDI: Bool
    let daily: Int
    let unit: String
    let sub: String
}

struct Recipe: Codable {
    let uri: String
    let label: String
    let image: String
    let images: RecipeImages
    let source: String
    let url: String
    let shareAs: String
    let yield: Int
    let dietLabels: [String]
    let healthLabels: [String]
    let cautions: [String]
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let calories: Int
    let glycemicIndex: Int
    let totalCO2Emissions: Int
    let co2EmissionsClass: String
    let totalWeight: Int
    let cuisineType: [String]
    let mealType: [String]
    let dishType: [String]
    let instructions: [String]
    let tags: [String]
    let externalId: String
    let digest: [Digest]
}

struct SearchResult: Codable {
    let from: Int
    let to: Int
    let count: Int
    let links: Links
    let hits: [Hit]
    
    enum CodingKeys: String, CodingKey {
        case from
        case to
        case count
        case links = "_links"
        case hits
    }
}

struct Links: Codable {
    let selfLink: Link
    let nextLink: Link
    
    enum CodingKeys: String, CodingKey {
        case selfLink = "self"
        case nextLink = "next"
    }
}

struct Link: Codable {
    let href: String
    let title: String
}

struct Hit: Codable {
    let recipe: Recipe
    let links: Links
    
    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}


class RecipiesService {
    private let ApiURL: String = "https://api.edamam.com/api/recipes/v2"
    
    private var session: URLSession
        
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getRecipes(foods: String, callBack: @escaping (Bool, SearchResult?) -> Void) {
        let key = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_KEY") as! String
        
        let id = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_API_ID") as! String
        
        var urlComponents = URLComponents(string: ApiURL)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: foods),
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
                            let recipiesData = try JSONDecoder().decode(SearchResult.self, from: data)
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
