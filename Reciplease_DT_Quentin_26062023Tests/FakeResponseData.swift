//
//  FakeResponseData.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 24/07/2023.
//

import Foundation

class FakeResponseData {
    // MARK: - Data
    
    // Correct data for the method getRecipies
    static var recipiesCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "RecipiesSearch", withExtension: "json") else {
            fatalError("RecipiesSearch.json is not found.")
        }
        return try? Data(contentsOf: url)
    }
    
    // Correct data for the method getRate
    static var autoCompleteCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        guard let url = bundle.url(forResource: "FoodAutoComplete", withExtension: "json") else {
            fatalError("FoodAutoComplete.json is not found.")
        }
        return try? Data(contentsOf: url)
    }
    
    // Incorrect data for all JSON
    static let incorrectData = "error".data(using: .utf8)!
    
    // MARK: - Response
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    // MARK: - Error
    
    class AllError: Error {}
    static let error = AllError()
}
