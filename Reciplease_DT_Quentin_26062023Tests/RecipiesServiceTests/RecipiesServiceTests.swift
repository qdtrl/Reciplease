//
//  RecipiesServiceTests.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023

final class RecipiesServiceTests: XCTestCase {
                
    func testServiceShouldPostFailedCallbackIfError() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfNoData() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: FakeResponseData.recipiesCorrectData, response: FakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfNilData() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceCorrectAnswer() {
        // Given
        let recipleaseService = RecipiesService(session: URLSessionFake(data: FakeResponseData.recipiesCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        recipleaseService.getRecipes(foods: "chicken") { (success, recipiesData) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(recipiesData)
            
            
            expectation.fulfill()
        }
    }
        
        
}
