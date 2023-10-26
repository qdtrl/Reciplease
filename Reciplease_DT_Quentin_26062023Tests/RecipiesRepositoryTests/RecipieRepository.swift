//
//  RecipieRepositoryTests.swift
//  Reciplease_DT_Quentin_26062023Tests
//
//  Created by Quentin Dubut-Touroul on 29/07/2023.
//

import XCTest
@testable import Reciplease_DT_Quentin_26062023

final class RecipieRepositoryTests: XCTestCase {

    var sut: RecipieRepository!
    
    override func setUp() {
        super.setUp()
        
        sut = RecipieRepository(coreDataStack: CoreDataStack.shared)
        sut.deleteAllData()
    }
    
    override func tearDown() {
        super.tearDown()
        sut.deleteAllData()
    }
    
    func testCeateRecipieWithModel() {
        sut.deleteAllData()
        let recipie = Recipie(context: CoreDataStack.shared.viewContext)
        
        let recipe = RecipeStruc(from: recipie)
        let results = RecipeResponse(hits: [Reciplease_DT_Quentin_26062023.RecipeResponse.HitResponse(recipe: Reciplease_DT_Quentin_26062023.RecipeResponse.Recipe(label: "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe", image: "https://edamam-product-images", ingredientLines: ["1 cup sugar", "Finely grated zest of 3 lemons", "4 large eggs", "3/4 cup freshly squeezed lemon juice (from 4 to 5 lemons)", "2 sticks plus 5 tablespoons (21 tablespoons; 10 1/2 ounces) unsalted butter, at room temperature and cut into tablespoon-sized pieces", "1 fully-baked 9-inch tart shell"], totalTime: 0.0, url: "http://www.seriouseats.com/recipes/2008/04/lemon-lemon-lemon-cream-recipe.html", yield: 8.0, dietLabels: ["Low-Sodium"], healthLabels: ["Low Potassium", "Kidney-Friendly", "Vegetarian", "Pescatarian", "Peanut-Free", "Tree-Nut-Free", "Soy-Free", "Fish-Free", "Shellfish-Free", "Pork-Free", "Red-Meat-Free", "Crustacean-Free", "Celery-Free", "Mustard-Free", "Sesame-Free", "Lupine-Free", "Mollusk-Free", "Alcohol-Free", "Kosher"], mealType: ["lunch/dinner"])), Reciplease_DT_Quentin_26062023.RecipeResponse.HitResponse(recipe: Reciplease_DT_Quentin_26062023.RecipeResponse.Recipe(label: "", image: "", ingredientLines: [""], totalTime: 0, url: "", yield: 0, dietLabels: [], healthLabels: [], mealType: []))])
        
        
        let recipies = results.hits.map { hit -> RecipeStruc in
            RecipeStruc(from: hit)
        }
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")

        XCTAssertEqual(recipe.id, "")
        XCTAssertEqual(recipies.first!.id, "Baking with Dorie: Lemon-Lemon Lemon Cream Recipe")
        
        expectation.fulfill()
        sut.deleteAllData()
    }
    
    func testAddRecipie() {
        sut.deleteAllData()
        // Given
        let recipie = Recipie(context: CoreDataStack.shared.viewContext)
        recipie.id = "123"
        recipie.title = "Test Recipe"
        recipie.subtitle = "Test Subtitle"
        recipie.image = "Test Image"
        recipie.time = 10
        recipie.instructions = "Test Instructions"
        recipie.redirection = "Test Redirection"
        recipie.yield = 30
        recipie.isFavorite = true
        let recipe = RecipeStruc(from: recipie)
        
        // When
        sut.addRecipie(recipieInit: recipe)
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRecipies { (recipes) in
            XCTAssertEqual(recipes.first?.id, "123")
            XCTAssertEqual(recipes.first?.title, "Test Recipe")
            XCTAssertEqual(recipes.first?.subtitle, "Test Subtitle")
            XCTAssertEqual(recipes.first?.image, "Test Image")
            XCTAssertEqual(recipes.first?.time, 10)
            XCTAssertEqual(recipes.first?.instructions, "Test Instructions")
            XCTAssertEqual(recipes.first?.redirection, "Test Redirection")
            XCTAssertEqual(recipes.first?.yield, 30)
            XCTAssertTrue(recipes.first?.isFavorite ?? false)
            expectation.fulfill()
        }
        sut.deleteAllData()
    }
    
    func testGetRecipies() {
        sut.deleteAllData()
        // Given
        let recipie1 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie1.id = "123"
        recipie1.title = "Test Recipe 1"
        recipie1.subtitle = "Test Subtitle 1"
        recipie1.image = "Test Image 1"
        recipie1.time = 40
        recipie1.instructions = "Test Instructions 1"
        recipie1.redirection = "Test Redirection 1"
        recipie1.yield = 100
        recipie1.isFavorite = true
        
        let recipe1 = RecipeStruc(from: recipie1)
        
        sut.addRecipie(recipieInit: recipe1)

        let recipie2 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie2.id = "456"
        recipie2.title = "Test Recipe 2"
        recipie2.subtitle = "Test Subtitle 2"
        recipie2.image = "Test Image 2"
        recipie2.time = 1402
        recipie2.instructions = "Test Instructions 2"
        recipie2.redirection = "Test Redirection 2"
        recipie2.yield = 2
        recipie2.isFavorite = false
        
        
        let recipe2 = RecipeStruc(from: recipie2)
        
        sut.addRecipie(recipieInit: recipe2)
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRecipies { (recipes) in
            // Then
            XCTAssertEqual(recipes.first?.id, "123")
            XCTAssertEqual(recipes.first?.title, "Test Recipe 1")
            XCTAssertEqual(recipes.first?.subtitle, "Test Subtitle 1")
            XCTAssertEqual(recipes.first?.image, "Test Image 1")
            XCTAssertEqual(recipes.first?.time, 40)
            XCTAssertEqual(recipes.first?.instructions, "Test Instructions 1")
            XCTAssertEqual(recipes.first?.redirection, "Test Redirection 1")
            XCTAssertEqual(recipes.first?.yield, 100)
            XCTAssertTrue(recipes.first?.isFavorite ?? false)
            
            XCTAssertEqual(recipes.last?.id, "456")
            XCTAssertEqual(recipes.last?.title, "Test Recipe 2")
            XCTAssertEqual(recipes.last?.subtitle, "Test Subtitle 2")
            XCTAssertEqual(recipes.last?.image, "Test Image 2")
            XCTAssertEqual(recipes.last?.time, 1402)
            XCTAssertEqual(recipes.last?.instructions, "Test Instructions 2")
            XCTAssertEqual(recipes.last?.redirection, "Test Redirection 2")
            XCTAssertEqual(recipes.last?.yield, 2)
            expectation.fulfill()
        }
        sut.deleteAllData()
    }
    
    func testGetRecipieById() {
        sut.deleteAllData()
        // Given
        let recipie1 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie1.id = "123"
        recipie1.title = "Test Recipe 1"
        recipie1.subtitle = "Test Subtitle 1"
        recipie1.image = "Test Image 1"
        recipie1.time = 40
        recipie1.instructions = "Test Instructions 1"
        recipie1.redirection = "Test Redirection 1"
        recipie1.yield = 100
        recipie1.isFavorite = true
        
        let recipie2 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie2.id = "456"
        recipie2.title = "Test Recipe 2"
        recipie2.subtitle = "Test Subtitle 2"
        recipie2.image = "Test Image 2"
        recipie2.time = 1402
        recipie2.instructions = "Test Instructions 2"
        recipie2.redirection = "Test Redirection 2"
        recipie2.yield = 2
        recipie2.isFavorite = false
        
        let recipie3 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie3.id = "123"
        recipie3.title = "Test Recipe 1"
        recipie3.subtitle = "Test Subtitle 1"
        recipie3.image = "Test Image 1"
        recipie3.time = 40
        recipie3.instructions = "Test Instructions 1"
        recipie3.redirection = "Test Redirection 1"
        recipie3.yield = 100
        recipie3.isFavorite = false
        
        let recipe1 = RecipeStruc(from: recipie1)
        let recipe2 = RecipeStruc(from: recipie2)
        let recipe3 = RecipeStruc(from: recipie3)
        sut.addRecipie(recipieInit: recipe1)
        sut.addRecipie(recipieInit: recipe2)
        sut.addRecipie(recipieInit: recipe3)

        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRecipieById(id: "123") { (recipe) in
            
            // Then
            XCTAssertEqual(recipe.id, "123")
            XCTAssertEqual(recipe.title, "Test Recipe 1")
            XCTAssertEqual(recipe.subtitle, "Test Subtitle 1")
            XCTAssertEqual(recipe.image, "Test Image 1")
            XCTAssertEqual(recipe.time, 40)
            XCTAssertEqual(recipe.instructions, "Test Instructions 1")
            XCTAssertEqual(recipe.redirection, "Test Redirection 1")
            XCTAssertEqual(recipe.yield, 100)
            XCTAssertTrue(recipe.isFavorite)
            expectation.fulfill()
        }
        sut.deleteAllData()
    }
    
    func testRemove() {
        sut.deleteAllData()
        // Given
        let recipie1 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie1.id = "123"
        recipie1.title = "Test Recipe 1"
        recipie1.subtitle = "Test Subtitle 1"
        recipie1.image = "Test Image 1"
        recipie1.time = 40
        recipie1.instructions = "Test Instructions 1"
        recipie1.redirection = "Test Redirection 1"
        recipie1.yield = 100
        recipie1.isFavorite = true
        
        let recipe1 = RecipeStruc(from: recipie1)
        
        

        let recipie2 = Recipie(context: CoreDataStack.shared.viewContext)
        recipie2.id = "456"
        recipie2.title = "Test Recipe 2"
        recipie2.subtitle = "Test Subtitle 2"
        recipie2.image = "Test Image 2"
        recipie2.time = 1402
        recipie2.instructions = "Test Instructions 2"
        recipie2.redirection = "Test Redirection 2"
        recipie2.yield = 2
        recipie2.isFavorite = false
        
        
        let recipe2 = RecipeStruc(from: recipie2)
        
        
        sut.deleteAllData()
        sut.addRecipie(recipieInit: recipe1)
        sut.addRecipie(recipieInit: recipe2)
        
        // When
        sut.remove(id: "123")
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRecipies { (recipes) in
            print(recipes)
            XCTAssertEqual(recipes.first?.id, "456")
            XCTAssertEqual(recipes.first?.title, "Test Recipe 2")
            XCTAssertEqual(recipes.first?.subtitle, "Test Subtitle 2")
            XCTAssertEqual(recipes.first?.image, "Test Image 2")
            XCTAssertEqual(recipes.first?.time, 1402)
            XCTAssertEqual(recipes.first?.instructions, "Test Instructions 2")
            XCTAssertEqual(recipes.first?.redirection, "Test Redirection 2")
            XCTAssertEqual(recipes.first?.yield, 2)
            XCTAssertEqual(recipes.first?.isFavorite, true)
            expectation.fulfill()
        }
    }
    
    func testRemoveWrongId() {
        sut.deleteAllData()
        var count = 0
        sut.getRecipies { (recipes) in
            count = recipes.count
        }
        // When
        sut.remove(id: "wrong")
        
        // Then
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        sut.getRecipies { (recipes) in
            XCTAssertEqual(recipes.count, count)
           
            expectation.fulfill()
        }
        sut.deleteAllData()
    }

}
