//
//  FoodAutoCompleteServiceTests.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023

final class FoodAutoCompleteServiceTests: XCTestCase {
        
    func testServiceShouldPostFailedCallbackIfError() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfNoData() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: nil, response: nil, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfIncorrectResponse() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: FakeResponseData.recipiesCorrectData, response: FakeResponseData.responseKO, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfIncorrectData() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: FakeResponseData.incorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceShouldPostFailedCallbackIfNilData() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: nil, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, searchResult) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(searchResult)
            expectation.fulfill()
        }
    }
    
    func testServiceCorrectAnswer() {
        // Given
        let foodAutoCompleteService = FoodAutoCompleteService(session: URLSessionFake(data: FakeResponseData.autoCompleteCorrectData, response: FakeResponseData.responseOK, error: nil))
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        foodAutoCompleteService.getResultsFrom(word: "chi") { (success, resultData) in
            // Then
            XCTAssertTrue(success)
            XCTAssertNotNil(resultData)
            
            let shouldBeThis = [
                "chi",
                "chia",
                "chin",
                "chini",
                "chile",
                "chili",
                "chips",
                "chiku",
                "chive",
                "chivda"
            ]
            
            XCTAssertTrue(shouldBeThis == resultData)
            
            expectation.fulfill()
        }
    }
}
