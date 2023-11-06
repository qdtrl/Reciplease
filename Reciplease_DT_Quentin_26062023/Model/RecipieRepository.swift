//
//  RecipieRepository.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import Foundation
import CoreData
import UIKit

final class RecipieRepository {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    func deleteAllData() -> Result<Void, Error> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipie")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try coreDataStack.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                coreDataStack.viewContext.delete(objectData)
            }
            
            do {
                try coreDataStack.viewContext.save()
                return .success(())
            } catch let saveError {
                return .failure(saveError)
            }
        } catch let fetchError {
            return .failure(fetchError)
        }
    }
    
    func addRecipie(recipieInit: RecipeStruc) -> Result<Void, Error> {
        let recipie = Recipie(context: coreDataStack.viewContext)
        recipie.id = recipieInit.id
        recipie.title = recipieInit.title
        recipie.subtitle = recipieInit.subtitle
        recipie.image = recipieInit.image
        recipie.time = recipieInit.time
        recipie.instructions = recipieInit.instructions
        recipie.redirection = recipieInit.redirection
        recipie.yield = recipieInit.yield
        recipie.isFavorite = true

        do {
           try coreDataStack.viewContext.save()
           return .success(())
        } catch let error {
           return .failure(error)
        }
    }
    
    func getRecipies(callback: @escaping (Result<[RecipeStruc], Error>) -> Void) {
        do {
            let recipes = try coreDataStack.viewContext.fetch(Recipie.fetchRequest())
            let recipeStructs = recipes.map { recipe -> RecipeStruc in
                RecipeStruc(from: recipe)
            }
            callback(.success(recipeStructs))
        } catch let error {
            callback(.failure(error))
        }
    }
    
    func getRecipieById(id: String, callback: @escaping (Result<RecipeStruc, Error>) -> Void) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let recipies = try? coreDataStack.viewContext.fetch(request) else {
            callback(.failure(NSError()))
            return
        }
        
        if recipies.count > 0 {
            if let recipie = recipies.first {
                let result = RecipeStruc(from: recipie)
                callback(.success(result))
                return
            }
        } else {
            callback(.failure(NSError(domain: "No recipie matching id", code: 404, userInfo: ["\(id) not found": id])))
        }
    }
    
    func remove(id: String, callback: @escaping (Result<Void, Error>) -> Void) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let items = try coreDataStack.viewContext.fetch(request)
            if let itemToDelete = items.first {
                coreDataStack.viewContext.delete(itemToDelete)
                do {
                    try coreDataStack.viewContext.save()
                    callback(.success(()))
                } catch let saveError {
                    callback(.failure(saveError))
                }
            } else {
                callback(.failure(NSError(domain: "No recipie matching id", code: 404, userInfo: ["\(id) not found": id])))
            }
        } catch let error {
            callback(.failure(error))
        }
    }
}
