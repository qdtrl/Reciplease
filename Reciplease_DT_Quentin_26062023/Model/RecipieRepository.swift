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
    
    
    func addRecipie(with
                    id: String,
                    title: String,
                    image: String,
                    time: Double,
                    instructions: String,
                    redirection: String,
                    for recipie: Recipie, callback: @escaping () -> Void){
        let recipie = Recipie(context: coreDataStack.viewContext)
        recipie.title = title
        recipie.id = id
        recipie.instructions = instructions
        recipie.time = time
        recipie.redirection = redirection
        recipie.image = image
        recipie.isFavorite = true
        do {
            try coreDataStack.viewContext.save()
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
    
    func remove(recipie: Recipie, callback: @escaping () -> Void) {
        coreDataStack.viewContext.delete(recipie)
        do {
            try coreDataStack.viewContext.save()
            callback()
        } catch {
            print("We were unable to remove \(recipie.description)")
        }
    }
    
}
