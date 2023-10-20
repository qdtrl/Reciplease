//
//  Recipie.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import Foundation
import CoreData

class Recipie: NSManagedObject {
}

struct RecipeStruc {
    private(set) var image: String
    private(set) var title: String
    private(set) var time: Int16
    private(set) var id: String
    private(set) var redirection: String
    private(set) var subtitle: String
    private(set) var yield: Int32
    var isFavorite: Bool
    private(set) var instructions: String
    
// si on traduit depuis l'api
    init(from response: RecipeResponse.HitResponse) {
        self.image = response.recipe.image
        self.title = response.recipe.label
        self.yield = Int32(response.recipe.yield)
        self.time = Int16(response.recipe.totalTime)
        self.id = response.recipe.label
        self.redirection = response.recipe.url
        self.isFavorite = false
        self.instructions = response.recipe.ingredientLines.joined(separator: ",")
        
        if let diet = response.recipe.dietLabels.first,
           let healthLabel = response.recipe.healthLabels.first,
           let mealType = response.recipe.mealType.first {
            self.subtitle = "#\(diet) #\(healthLabel) #\(mealType)"
        } else {
            self.subtitle = ""
        }
        
    }
    
//  si on traduit depuis la base de donnée
    init(from coreDataObject: Recipie) {
        if let image = coreDataObject.image,
            let title = coreDataObject.title,
            let id = coreDataObject.id,
            let subtitle = coreDataObject.subtitle,
            let redirection = coreDataObject.redirection,
            let instructions = coreDataObject.instructions {
            self.image = image
            self.title = title
            self.time = coreDataObject.time
            self.id = id
            self.yield = coreDataObject.yield
            self.subtitle = subtitle
            self.redirection = redirection
            self.isFavorite = coreDataObject.isFavorite
            self.instructions = instructions
        } else {
            self.image = ""
            self.title = ""
            self.time = 0
            self.id = ""
            self.redirection = ""
            self.isFavorite = false
            self.instructions = ""
            self.subtitle = ""
            self.yield = 0
        }
    }
}
