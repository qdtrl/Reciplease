//
//  CoreDataStack.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import Foundation
import CoreData

final class CoreDataStack {
//    MARK: - Properties
    
    private let persistentContainerName = "Reciplease"
    
//    MARK: - Singleton
    
    static let shared = CoreDataStack()
    
//    MARK: - Public
    
    var viewContext: NSManagedObjectContext {
        return CoreDataStack.shared.persistentContainer.viewContext
    }
    

//    MARK: - Private
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
