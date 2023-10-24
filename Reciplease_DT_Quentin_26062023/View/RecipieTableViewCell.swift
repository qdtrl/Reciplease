//
//  RecipieTableViewCell.swift
//  Reciplease_DT_Quentin_26062023
//
//  Created by Quentin Dubut-Touroul on 06/10/2023.
//

import UIKit

class RecipieTableViewCell: UITableViewCell {

    @IBOutlet weak var imageRecipie: UIImageView!
    @IBOutlet weak var titleRecipie: UILabel!
    @IBOutlet weak var subtitleRecipie: UILabel!
    @IBOutlet weak var timerRecipie: UILabel!
    @IBOutlet weak var ratesRecipie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
    
    func configure(recipie: RecipeStruc) {
        guard let url = URL(string: recipie.image) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Failed fetching image:", error as Any)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Not a proper HTTPURLResponse or statusCode")
                return
            }

            DispatchQueue.main.async {
                self.imageRecipie.image = UIImage(data: data!)
            }
        }.resume()
        
        
        self.timerRecipie.text = getTimeIntoString(time: recipie.time)
        self.titleRecipie.text = recipie.title
        self.subtitleRecipie.text = recipie.subtitle
        self.ratesRecipie.text = "\(recipie.yield)"

    }
}
