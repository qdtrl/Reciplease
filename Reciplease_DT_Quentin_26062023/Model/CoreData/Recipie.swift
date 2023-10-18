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
    private(set) var time: Double
    private(set) var id: String
    private(set) var redirection: String
    private(set) var isFavorite: Bool
    private(set) var instructions: String
    
// si on traduit depuis l'api
    init(from response: RecipeResponse.HitResponse) {
        self.image = response.recipe.image
        self.title = response.recipe.label
        self.time = response.recipe.totalTime
        self.id = response.recipe.label
        self.redirection = response.recipe.uri
        self.isFavorite = false
        self.instructions = response.recipe.ingredientLines.joined(separator: ",")
    }
    
//  si on traduit depuis la base de donnée
    init(from coreDataObject: Recipie) {
        if let image = coreDataObject.image,
            let title = coreDataObject.title,
            let id = coreDataObject.id,
            let redirection = coreDataObject.redirection,
            let instructions = coreDataObject.instructions {
            self.image = image
            self.title = title
            self.time = coreDataObject.time
            self.id = id
            self.redirection = redirection
            self.isFavorite = coreDataObject.isFavorite
            self.instructions = instructions
        } else {
            self.image = ""
            self.title = ""
            self.time = 0.0
            self.id = ""
            self.redirection = ""
            self.isFavorite = false
            self.instructions = ""
        }
    }
}
