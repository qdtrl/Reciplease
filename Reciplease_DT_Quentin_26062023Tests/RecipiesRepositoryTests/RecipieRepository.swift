//
//  RecipieRepositoryTests.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023

final class RecipieRepositoryTests: XCTestCase {
    var repository: RecipieRepository!
    let recipe = RecipeStruc(from: Reciplease_DT_Quentin_26062023.RecipeResponse.HitResponse(recipe: Reciplease_DT_Quentin_26062023.RecipeResponse.Recipe(label: "Chicken Vesuvio", image: "link", ingredientLines: ["1/2 cup olive oil", "5 cloves garlic, peeled", "2 large russet potatoes, peeled and cut into chunks", "1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)", "3/4 cup white wine", "3/4 cup chicken stock", "3 tablespoons chopped parsley", "1 tablespoon dried oregano", "Salt and pepper", "1 cup frozen peas, thawed"], totalTime: 60.0, url: "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html", yield: 4.0, dietLabels: ["Low-Carb"], healthLabels: ["Mediterranean", "Dairy-Free"], mealType: ["lunch/dinner"])))
    
    let recipe2 = RecipeStruc(from: Reciplease_DT_Quentin_26062023.RecipeResponse.HitResponse(recipe: Reciplease_DT_Quentin_26062023.RecipeResponse.Recipe(label: "Chicken Vesuvio", image: "link", ingredientLines: ["1/2 cup olive oil", "5 cloves garlic, peeled", "2 large russet potatoes, peeled and cut into chunks", "1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)", "3/4 cup white wine", "3/4 cup chicken stock", "3 tablespoons chopped parsley", "1 tablespoon dried oregano", "Salt and pepper", "1 cup frozen peas, thawed"], totalTime: 60.0, url: "http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html", yield: 4.0, dietLabels: [], healthLabels: [], mealType: [])))
    
    
    override func setUp() {
        super.setUp()
        repository = RecipieRepository(coreDataStack: CoreDataStack.shared)
    }
    
    override func tearDown() {
        super.tearDown()
        repository = nil
    }
    
    func testDeleteAllData() {
        // Given
        let expectation = XCTestExpectation(description: "Delete all data")
        let recipie = Recipie(context: CoreDataStack.shared.viewContext)

        let recipe3 = RecipeStruc(from: recipie)
        _ = repository.addRecipie(recipieInit: recipe)
        _ = repository.addRecipie(recipieInit: recipe2)
        _ = repository.addRecipie(recipieInit: recipe3)


        
        // When
        let result = repository.deleteAllData()
        
        // Then
        switch result {
        case .success:
            expectation.fulfill()
        case .failure:
            XCTFail("Delete all data failed")
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testAddRecipie() {
        // Given
        let expectation = XCTestExpectation(description: "Add recipie")
        
        // When
        let result = repository.addRecipie(recipieInit: recipe)
        
        // Then
        switch result {
        case .success:
            expectation.fulfill()
        case .failure:
            XCTFail("Add recipie failed")
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetRecipies() {
        // Given
        let expectation = XCTestExpectation(description: "Get recipies")
        
        _ = repository.addRecipie(recipieInit: recipe)
        
        // When
        repository.getRecipies { result in
            // Then
            switch result {
            case .success(let recipes):
                XCTAssertEqual(recipes.first?.id, "Chicken Vesuvio")
                XCTAssertEqual(recipes.first?.title, "Chicken Vesuvio")
                XCTAssertEqual(recipes.first?.image, "link")
                expectation.fulfill()
            case .failure:
                XCTFail("Get recipies failed")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetRecipieById() {
        // Given
        let expectation = XCTestExpectation(description: "Get recipie by id")
        
        _ = repository.addRecipie(recipieInit: recipe)
        
        // When
        repository.getRecipieById(id: "Chicken Vesuvio") { result in
            // Then
            switch result {
            case .success(let recipe):
                XCTAssertEqual(recipe.id, "Chicken Vesuvio")
                XCTAssertEqual(recipe.title, "Chicken Vesuvio")
                XCTAssertEqual(recipe.image, "link")
                expectation.fulfill()
            case .failure:
                XCTFail("Get recipies failed")
            }
            
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testGetRecipieWithWrongId() {
        // Given
        let expectation = XCTestExpectation(description: "Get recipie by wrong id")
        
        _ = repository.addRecipie(recipieInit: recipe)
        
        // When
        repository.getRecipieById(id: "wrong") { result in
            // Then
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertNotNil(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRemove() {
        // Given
        let expectation = XCTestExpectation(description: "Remove recipie")
        
        _ = repository.addRecipie(recipieInit: recipe)
        
        // When
        repository.remove(id: "Chicken Vesuvio") { result in
            // Then
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Remove recipie failed")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testRemoveWrongId() {
        // Given
        let expectation = XCTestExpectation(description: "Remove recipie")
        
        _ = repository.addRecipie(recipieInit: recipe)
        
        // When
        repository.remove(id: "wrong") { result in
            // Then
            switch result {
            case .success(let recipe):
                XCTAssertNil(recipe)
            case .failure(let error):
                XCTAssertNotNil(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
