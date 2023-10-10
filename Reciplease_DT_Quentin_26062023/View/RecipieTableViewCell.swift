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
    @IBOutlet weak var timerRecipie: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(recipie: Recipie) {
        guard let url = recipie.image else {
            return
        }
        if let imageUrl = URL(string: url) {
            // Use URLSession to download the image data asynchronously
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let error = error {
                    // Handle any errors that occur during the download
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { [ weak self ] in
                        self?.imageRecipie.image = image
                        self?.timerRecipie.text = "\(recipie.time)"
                        self?.titleRecipie.text = recipie.title
                    }
                }
            }
        }
    }
}
