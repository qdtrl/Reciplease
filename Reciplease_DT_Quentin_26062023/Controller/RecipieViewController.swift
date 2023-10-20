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
            recipieRepository.remove(id: idString)
            recipie?.isFavorite = false
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            recipieRepository.addRecipie(recipieInit: recipie!)
            recipie?.isFavorite = true
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }

    @IBAction func actionRedirectionButton(_ sender: UIButton) {
        guard let link = self.recipie?.redirection else { return }
        
        guard let url = URL(string: link) else { return }
        
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfFavorite()
        updateView()
        tableView.reloadData()
    }
    
    private func checkIfFavorite() {
        guard let id = self.recipie?.id else { return }

        recipieRepository.getRecipieById(id: id, callback: {[weak self] recipie in
            if recipie.isFavorite {
                self?.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
         })
    }
    
    private func getTimeIntoString(time:Int16) -> String {
        var timeInString: String
        if time > 60 {
            timeInString = "\(time/60)h"
            if time % 60 < 10 {
                timeInString += "0\(time % 60)"
            } else {
                timeInString += "\(time % 60)"
            }
        } else {
            timeInString = "\(time)m"
        }
        return timeInString
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
                        self?.timer.text = self!.getTimeIntoString(time: time)
                        self?.yielLabel.text = "\(yield)"
                        self?.titleLabel.text = self?.recipie?.title
                        self?.subtitleLabel.text = self?.recipie?.subtitle
                    }
                } else {
                    print("Failed to create UIImage from data or data is nil.")
                }
            }.resume()
        } else {
            print("Failed to create URL from link or link is nil.")
        }
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
        
        return cell
    }
}
