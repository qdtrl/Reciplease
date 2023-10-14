//
//  RecipieRepository.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import Foundation
import CoreData

final class RecipieRepository {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack = CoreDataStack.shared) {
        self.coreDataStack = coreDataStack
    }
    
    
    func addRecipie(recipieInit: Recipie){
        var recipie = Recipie(context: coreDataStack.viewContext)
        recipie = recipieInit
        
        recipie.isFavorite = true
        do {
            try coreDataStack.viewContext.save()
            print("saved success")
        } catch {
            print("We were unable to save \(recipie)")
        }
    }
    
    func getRecipies(callback: @escaping ([Recipie]) -> Void) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()
        
        guard let recipies = try? coreDataStack.viewContext.fetch(request) else {
            callback([])
            return
        }
        
        callback(recipies)
    }
    
    func getRecipieById(recipie: Recipe, callback: @escaping (Recipie) -> Void) {
        let request: NSFetchRequest<Recipie> = Recipie.fetchRequest()
        
        let predicate = NSPredicate(format: "id", id)
        
        request.predicate = predicate
        
        guard let recipies = try? coreDataStack.viewContext.fetch(request) else {
            callback(recipie)
            return
        }
        
        callback(recipies)
    }
    
    func remove(recipie: Recipie) {
        coreDataStack.viewContext.delete(recipie)
        do {
            try coreDataStack.viewContext.save()
        } catch {
            print("We were unable to remove \(recipie.description)")
        }
    }
    
}
