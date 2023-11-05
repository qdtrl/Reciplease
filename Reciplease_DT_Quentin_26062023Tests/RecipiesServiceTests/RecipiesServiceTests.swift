//
//  RecipiesServiceTests.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023
import Alamofire

final class RecipiesServiceTests: XCTestCase {
    var ingredients: String = "chicken"
    
    let networkManager = RecipiesService() // Your network manager class

    override func setUp() {
        super.setUp()

        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDown() {
        super.tearDown()

        URLProtocol.unregisterClass(MockURLProtocol.self)
    }
    
    func testGetRecipies() {
        let expectation = XCTestExpectation(description: "Get all recipies")
        let responseData = FakeResponseData.recipiesCorrectData
        let response = FakeResponseData.responseOK

        MockURLProtocol.mockResponse = response
        MockURLProtocol.mockData = responseData
        
        networkManager.getRecipes(foods: ingredients) { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure:
                XCTFail("Request failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
    
    func testGetNextRecipies() {
        let expectation = XCTestExpectation(description: "Get all next recipies")
        let responseData = FakeResponseData.recipiesCorrectData
        let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)

        MockURLProtocol.mockResponse = response
        MockURLProtocol.mockData = responseData
        
        networkManager.getNextRecipies(url: "https://api.edamam.com/api/recipes/v2?q=chicken&app_key=c609bd02eadc9967fccb3d66a4ee554b&_cont=CHcVQBtNNQphDmgVQntAEX4BYldtBAYEQ21GBWQaaldyDAQCUXlSB2ZCNl17BgcESmVBAjAaZ1RyUFFUEmAWB2tFMVQiBwUVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D&type=any&app_id=24a1e0a6") { result in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(let error):
                XCTFail("Request failed \(error)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
