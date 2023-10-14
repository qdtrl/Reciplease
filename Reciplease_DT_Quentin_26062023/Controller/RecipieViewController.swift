//
//  RecipieViewController.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 04/09/2023.
//

import UIKit
import CoreData

final class RecipieViewController: UIViewController {
    let coreDataStack = CoreDataStack.shared
    let recipieRepository = RecipieRepository()

    var recipie: Recipie?

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func actionFavoriteButton(_ sender: UIButton) {
        guard let isFavorite = recipie?.isFavorite else {
            return
        }
        
        if (isFavorite) {
            recipieRepository.remove(recipie: recipie!)
        } else {
            recipieRepository.addRecipie(recipieInit: recipie!)
        }
    }

    @IBAction func actionRedirectionButton(_ sender: UIButton) {
        guard let url = URL(string: String((self.recipie?.redirection)!)) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        updateView()
//        tableView.reloadData()
    }
    
    private func addFavorite() {
        
        
    }
    
    private func updateView() {
        guard let url = self.recipie?.image else {
            return
        }
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error as Any)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }

            DispatchQueue.main.async { [ weak self ] in
                self?.image.image = UIImage(data: data!)
                guard let time = self?.recipie?.time else {
                    return
                }
                self?.timer.text = "\(time)"
                self?.titleLabel.text = self?.recipie?.title
            }
        }.resume()                        
    }

}

extension RecipieViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recipie?.instructions?.split(separator: ", ").count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath)
        
        let instruction = recipie?.instructions?.split(separator: ",")[indexPath.row]
        
        guard let instruction = instruction else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = "- \(instruction)"
        
        return cell
    }
}
