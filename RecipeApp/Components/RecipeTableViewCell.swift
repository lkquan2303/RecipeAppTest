//
//  RecipeTableViewCell.swift
//  RecipeAppExample
//
//  Created by Uri on 11/29/20.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // recipeName.text = "13"
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(recipeInfo: RecipeModel) {
        if recipeInfo.name != nil {
            recipeName.text = recipeInfo.name
        }
        if recipeInfo.imageUrl != nil && !recipeInfo.imageUrl.isEmpty {
            let imageUrl: URL = URL(fileURLWithPath: recipeInfo.imageUrl)
            guard FileManager.default.fileExists(atPath: recipeInfo.imageUrl) else {
                 return // No image found!
            }
            if let imageData: Data = try? Data(contentsOf: imageUrl) {
                recipeImage.image = UIImage(data: imageData)
            }
        } else {
            recipeImage.image = UIImage(named: "default_food_image")
        }
    }
}
