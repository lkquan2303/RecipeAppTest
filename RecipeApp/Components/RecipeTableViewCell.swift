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
    }
    
    func setUpCellView(recipeDetails: RecipeModel) {
        recipeName.text = recipeDetails.name
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(recipeDetails.imageUrl)")
            let image    = UIImage(contentsOfFile: imageURL.path)
            recipeImage.image = image
        }
    }
}

