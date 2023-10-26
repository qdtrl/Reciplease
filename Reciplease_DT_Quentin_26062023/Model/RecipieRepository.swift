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
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipie")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try coreDataStack.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                coreDataStack.viewContext.delete(objectData)
                try coreDataStack.viewContext.save()
            }
        } catch let error {
            print("Detele all data in Recipie error :", error)
        }
    }
    
    func addRecipie(recipieInit: RecipeStruc){
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
            print("saved success")
        } catch {
            print("We were unable to save \(recipie)")
        }
    }
    
    func getRecipies(callback: @escaping ([RecipeStruc]) -> Void) {
        guard let recipies = try? coreDataStack.viewContext.fetch(Recipie.fetchRequest()) else {
            callback([])
            return
        }
        
        callback(recipies.map { recipie -> RecipeStruc in
            RecipeStruc(from: recipie)
        })
    }
    
    func getRecipieById(id: String, callback: @escaping (RecipeStruc) -> Void) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let recipies = try? coreDataStack.viewContext.fetch(request) else {
            callback(RecipeStruc(from: Recipie()))
            return
        }
        
        if recipies.count > 0 {
            if let recipie = recipies.first {
                let result = RecipeStruc(from: recipie)
                callback(result)
                return
            }
        }
    }
    
    func remove(id: String) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()

        request.predicate = NSPredicate(format: "id == %@", id)

        do {
           let item = try coreDataStack.viewContext.fetch(request)
            if let itemToDelete = item.first {
                coreDataStack.viewContext.delete(itemToDelete)
                try coreDataStack.viewContext.save()
                print("Deleted item with ID \(id)")
            } else {
                print("No item found with ID \(id)")
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
}
