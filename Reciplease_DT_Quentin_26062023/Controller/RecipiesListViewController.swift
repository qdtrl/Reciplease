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

    private var recipies: [RecipeStruc] = []

    @IBOutlet weak var emptyResults: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
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
                    self.alert(title: "Unable to connect", message: "Please connect to the Internet")
                    return
                }
            
                self.recipies = recipiesData.hits.map { hit -> RecipeStruc in
                    RecipeStruc(from: hit)
                }
                
                self.update(displayFavorites: false)
            }
        }
        tableView.reloadData()
    }
    
    private func update(displayFavorites: Bool) {
        DispatchQueue.main.async { [ weak self ] in
            if self?.recipies.count == 0 {
                self?.emptyResults.text = displayFavorites ? "No favorite recipes, add some first via search" : "No results with your combination of ingredients"
                self?.emptyResults.isHidden = false
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func alert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            action in
            NSLog(message);

            self.navigationController?.popViewController(animated: true)
        })

        present(alert, animated: true)
    }
}

extension RecipiesListViewController: UITableViewDataSource, UITableViewDelegate {
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
        
        let recipie = recipies[indexPath.row]
        
        cell.configure(recipie: recipie)
        
        cell.accessibilityHint = "Item of Recipie List"
        cell.accessibilityLabel = "\(recipie.title)"
        cell.accessibilityTraits = .image
        cell.accessibilityValue = "Medium"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipieDetail") as! RecipieViewController
        
        let recipie = recipies[indexPath.row]
        
        viewController.recipie = recipie
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
