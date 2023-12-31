//
//  RecipieViewController.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import UIKit
import CoreData

final class RecipieViewController: UIViewController {
    let recipieRepository = RecipieRepository()

    var recipie: RecipeStruc?

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var yielLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func actionFavoriteButton(_ sender: UIButton) {
        guard let isFavorite = recipie?.isFavorite else { return }

        if (isFavorite) {
            guard let idString = recipie?.id else { return }
            recipieRepository.remove(id: idString) { result in
                switch result {
                case .success:
                    self.recipie?.isFavorite = false
                    self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                case .failure(let error):
                    self.alert(title: "Error deleting item:", message: error.localizedDescription)
                }
            }
        } else {
            switch recipieRepository.addRecipie(recipieInit: recipie!) {
            case .success:
                recipie?.isFavorite = true
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                self.alert(title: "Favorite", message: "Recipe added successfully.")
            case .failure(let error):
                self.alert(title: "Favorite", message: "Error adding recipe: \(error)")
            }
        }
    }

    @IBAction func actionRedirectionButton(_ sender: UIButton) {
        guard let link = self.recipie?.redirection else { return }
        self.accessibilityHint = "Button for accessing instructions recipe"
        self.accessibilityLabel = "Redirect to \(link)"
        self.accessibilityTraits = .link
        guard let url = URL(string: link) else { return }
        
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInDB()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkInDB()
    }
    
    private func checkInDB() {
        guard let id = self.recipie?.id else { return }

        recipieRepository.getRecipieById(id: id) { recipie in
            switch recipie {
            case .success(_):
                self.recipie?.isFavorite = true
            case .failure(_):
                self.recipie?.isFavorite = false
            }
            self.checkIfFavorite()
         }
    }
    
    private func checkIfFavorite(){
        self.favoriteButton.accessibilityTraits = .button
        guard let isFavorite = self.recipie?.isFavorite else { return }

        if isFavorite {
            self.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.favoriteButton.accessibilityHint = "Button for delete the recipe to favories"
            self.favoriteButton.accessibilityLabel = "The Recipie is in your favorite"
        } else {
            self.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.favoriteButton.accessibilityHint = "Button for add the recipe to favories"
            self.favoriteButton.accessibilityLabel = "The Recipie is not in your favorite"
        }
    }
    
    private func updateView() {
        guard let link = self.recipie?.image else { return }

        if let url = URL(string: link) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Failed fetching image:", error )
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                if let data = data, let image = UIImage(data: data), let time = self.recipie?.time, let yield = self.recipie?.yield {
                    DispatchQueue.main.async { [ weak self ] in
                        self?.image.image = image
                        self?.image.accessibilityHint = "Image of the recipe"
                        self?.image.accessibilityLabel = self?.recipie?.title
                        self?.image.accessibilityTraits = .image
                        self?.timer.text = time.getTimeIntoString()
                        self?.timer.accessibilityHint = "Time of recipe preparation"
                        self?.timer.accessibilityLabel = time.getTimeIntoString()
                        self?.yielLabel.text = "\(yield)"
                        self?.yielLabel.accessibilityHint = "Rate of recipe"
                        self?.yielLabel.accessibilityLabel = "\(yield)"
                        self?.yielLabel.accessibilityValue = "Easy"
                        self?.titleLabel.text = self?.recipie?.title
                        self?.titleLabel.accessibilityHint = "Title of recipe"
                        self?.titleLabel.accessibilityLabel = self?.recipie?.title
                        self?.subtitleLabel.text = self?.recipie?.subtitle
                        self?.subtitleLabel.accessibilityHint = "# of recipe"
                        self?.subtitleLabel.accessibilityLabel = self?.recipie?.subtitle
                    }
                } else {
                    print("Failed to create UIImage from data or data is nil.")
                }
            }.resume()
        } else {
            print("Failed to create URL from link or link is nil.")
        }
        tableView.reloadData()
    }
    
    private func alert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {
            action in
            NSLog(message);
        })

        present(alert, animated: true)
    }
}

extension RecipieViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let instructions = recipie?.instructions else { return 0 }
        
        return instructions.split(separator: ", ").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
        
        guard let instructions = recipie?.instructions else { return UITableViewCell() }
        
        let instruction = instructions.split(separator: ",")[indexPath.row]
        
        cell.textLabel?.text = "- \(instruction)"
        cell.accessibilityHint = "Ingredient of the recipe"
        cell.accessibilityLabel = "- \(instruction)"
        cell.accessibilityValue = "Easy"
        
        return cell
    }
}
