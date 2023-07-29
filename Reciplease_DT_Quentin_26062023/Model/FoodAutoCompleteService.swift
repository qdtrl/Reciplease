//
//  FoodAutoCompleteService.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import Foundation

class FoodAutoCompleteService {
    private let ApiURL: String = "https://api.edamam.com/api/recipes/v2"
    
    private var session: URLSession
        
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getResultsFrom(word: String, callBack: @escaping (Bool, [String]?) -> Void) {
        let key = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_SEARCH_API_KEY") as! String
        
        let id = Bundle.main.object(forInfoDictionaryKey: "RECIPLEASE_SEARCH_API_ID") as! String
        
        var urlComponents = URLComponents(string: ApiURL)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: word),
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
                            print("DATA ::: \(data)")
                            let AutoCompleteData = try JSONDecoder().decode([String].self, from: data)
                            print("Data ::: \(AutoCompleteData)")
                            callBack(true, AutoCompleteData)
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
