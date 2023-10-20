//
//  RecipieRepository.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 20/10/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023

final class RecipieRepository: XCTestCase {
    func testRepositoryAddRecipie() {
        RecipieRepository().addRecipie(recipieInit: RecipeStruc(from: recipieInit))
        
    }
    
    func testRepositoryGetRecipies() {
        RecipieRepository().getRecipies()
        
    }
    
    func testRepositoryGetRecipieById() {
        RecipieRepository().getRecipieById(id: "Id")
        
    }
    
    func testRepositoryRemoveRecipieById() {
        RecipieRepository().remove(id: "Id")
        
    }
}
