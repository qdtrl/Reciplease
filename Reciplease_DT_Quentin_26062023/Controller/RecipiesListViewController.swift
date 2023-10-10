//
//  RecipiesListViewController.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import UIKit


class RecipiesListViewController: UIViewController {
    private let recipiesRepository = RecipieRepository()
    private let recipiesService = RecipiesService()
    
    var displayFavorites = true
    var ingredients: [String] = []

    private var recipies: [Recipie] = []

    @IBOutlet weak var emptyResults: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyResults.isHidden = true
        
        if displayFavorites {
            recipiesRepository.getRecipies(callback: { [weak self] recipies in
                self?.recipies = recipies
                self?.update(displayFavorites: true)
             })
        } else {
            recipiesService.getRecipes(foods: ingredients.joined(separator: ",").lowercased()) { (success, recipiesData) in
                guard let recipiesData = recipiesData, success == true else {
                    self.alert(title: "Connection Impossible", message: "Veuillez vous connecter à Internet")
                    return
                }
            
                let coreDataStack = CoreDataStack.shared
                recipiesData.hits.forEach{hitResponse in
                    
                    let recipie = Recipie(context: coreDataStack.viewContext)
                    
                    recipie.id = hitResponse.recipe.label
                    recipie.title = hitResponse.recipe.label
                    recipie.instructions = hitResponse.recipe.ingredientLines.joined(separator: ", ")
                    recipie.image = hitResponse.recipe.image
                    recipie.redirection = hitResponse.recipe.uri
                    recipie.isFavorite = false
                    recipie.time = hitResponse.recipe.totalTime

                    self.recipies.append(recipie)
                }
                
                self.update(displayFavorites: false)
            }
        }
    }
    
    func update(displayFavorites: Bool) {
        DispatchQueue.main.async { [ weak self ] in
            if self?.recipies.count == 0 {
                self?.emptyResults.text = displayFavorites ? "Aucune recette favorite, ajoutez en d'abord via la recherche" : "Aucun résultat avec votre combinaison d'ingrédients"
                self?.emptyResults.isHidden = false
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    func alert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            action in
            NSLog(message);
        })

        present(alert, animated: true)
    }

}

extension RecipiesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipieCell", for: indexPath)as? RecipieTableViewCell else {
            return UITableViewCell()
        }
        
        let food = recipies[indexPath.row]
        
        guard let title = food.title else {
            print("test")
            cell.textLabel?.text = "test"
            return cell
        }
        cell.textLabel?.text = title
        
        return cell

    }
    
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipiesList") as! RecipiesListViewController
//        
//        viewController.
//        self.navigationController?.pushViewController(viewController, animated: true)
    
}
