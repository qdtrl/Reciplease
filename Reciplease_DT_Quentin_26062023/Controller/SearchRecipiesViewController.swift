//
//  SearchRecipiesViewController.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import UIKit

class SearchRecipiesViewController: UIViewController {
    var ingredients:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        textSearch.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewUpdate()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var infoNoIngredient: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textSearch: UITextField!
    
    @IBAction func dismissKeyboad(_ sender: UITapGestureRecognizer) {
        textSearch.resignFirstResponder()
    }
    
    @IBAction func addSearch(_ sender: Any) {
        guard let ingredient = textSearch.text else {
            return
        }
        if ingredient != "" {
            ingredients.append(ingredient)
            textSearch.text = ""
            textSearch.resignFirstResponder()

            viewUpdate()
        } else {
            alert(title: "Unable to add", message: "Please enter an ingredient")
        }
       
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        ingredients = []
        
        viewUpdate()
    }
    

    @IBAction func searchButton(_ sender: UIButton) {
        if ingredients.count > 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RecipiesList") as! RecipiesListViewController
            
            viewController.displayFavorites = false
            viewController.ingredients = ingredients
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private func alert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            action in
            NSLog(message);
        })

        present(alert, animated: true)
    }
    
    private func viewUpdate() {
        clearButton.isHidden = ingredients.count == 0
        searchButton.isEnabled = ingredients.count > 0
        infoNoIngredient.isHidden = ingredients.count > 0
        tableView.reloadData()
    }
}

extension SearchRecipiesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath)
        
        let food = ingredients[indexPath.row]
        
        cell.textLabel?.text = "- \(food.capitalized)"
        
        return cell
    }
}

extension SearchRecipiesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = textSearch.text else {
            return true
        }
        if text == "" {
            self.textSearch.placeholder = "Lemon, Cheese, Tofu..."
        } else {
            ingredients.append(text)
            textSearch.text = ""
            
            viewUpdate()
        }
        
        return true
    }
}
