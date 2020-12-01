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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCellView(recipeDetails: RecipeModel) {
        recipeName.text = recipeDetails.name
        if isAppAlreadyLaunchedOnce(){
            recipeImage.sd_setImage(with: URL(string: recipeDetails.imageUrl))
        }
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(recipeDetails.imageUrl)")
            let image    = UIImage(contentsOfFile: imageURL.path)
            DispatchQueue.main.async {
                self.recipeImage.image = image
            }
        }
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if let isAppAlreadyLaunchedOnce = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
}

