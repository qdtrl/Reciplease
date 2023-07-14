//
//  RecipleaseService.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 26/06/2023.
//

import Foundation

class RecipleaseService {
    private let ApiURL: String = " https://api.edamam.com/api/recipes/v2"
    private let ApiID: String = "24a1e0a6"
    private let ApiKey: String = "c609bd02eadc9967fccb3d66a4ee554b"
    
    
    func getRecipe(callBack: @escaping (Bool, String?) -> Void) {
        var urlComponents = URLComponents(string: ApiURL + "/languages")!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: "chicken"),
            URLQueryItem(name: "app_id", value: ApiID),
            URLQueryItem(name: "app_key", value: ApiKey)
        ]
        
        
        
        guard let url = urlComponents.url else {
            callBack(false, nil)
            return
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
//                        do {
//                            let translationData = try JSONDecoder().decode(Languages.self, from: data)
//                            callBack(true, translationData)
//                            return
//                            
//                        } catch {
//                            print("Error decoding JSON: \(error)")
//                            callBack(false, nil)
//                            return
//                        }
                    }
                } else {
                    // API request failed
                    print("Error HTTP response status code: \(httpResponse.statusCode)")
                    callBack(false, nil)
                    return
                }
            }
        }
        task.resume()
    }
}
