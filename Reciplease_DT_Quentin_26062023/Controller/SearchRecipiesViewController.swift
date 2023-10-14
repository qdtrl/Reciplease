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
        clearButton.isHidden = true
        searchButton.isEnabled = false
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearButton.isHidden = true
        searchButton.isEnabled = ingredients.count > 0
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textSearch: UITextField!
    
    @IBAction func dismissKeyboad(_ sender: Any) {
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
            clearButton.isHidden = false
            searchButton.isEnabled = true
            tableView.reloadData()
        } else {
            alert(title: "Ajout Impossible", message: "Veuillez rentrer un ingredient")
        }
       
    }
    
    @IBAction func clearSearch(_ sender: Any) {
        ingredients = []
        clearButton.isHidden = true
        searchButton.isEnabled = false
        tableView.reloadData()
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
    
    func alert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            action in
            NSLog(message);
        })

        present(alert, animated: true)
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
        
        cell.textLabel?.text = "- \(food)"
        
        return cell
    }
}

extension SearchRecipiesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textSearch.resignFirstResponder()
        guard let text = textSearch.text else {
            return true
        }
        if text == "" {
            self.textSearch.placeholder = "Lemon, Cheese, Tofu..."
        }
        
        return true
    }
}
