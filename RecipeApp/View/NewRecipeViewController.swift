//
//  CRUDNewRecipeViewController.swift
//  RecipeAppExample
//
//  Created by Uri on 11/29/20.
//

import Foundation
import UIKit
import SDWebImage

class NewRecipeViewController: UIViewController{    
    
    weak var delegate: NewRecipeViewControllerDelegate?
    
    @IBAction func recipeDelete(_ sender: Any) {
        deleteRecipe()
    }
    
    @IBAction func recipeSave(_ sender: Any) {
        saveRecipe()
    }
    @IBAction func recipeChangePhoto(_ sender: Any) {
        title = "123"
        let fileName = "https://www.cookiemadness.net/wp-content/uploads/2018/01/sandyschocolatecake.jpg"
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + fileName
        let image = UIImage(contentsOfFile: path)
        newRecipeImg.image = image
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet var recipePickerView: UIPickerView!
    @IBOutlet weak var newRecipeImg: UIImageView!
    @IBOutlet weak var newRecipeType: UITextField!
    @IBOutlet weak var newRecipeIngredients: UITextView!
    @IBOutlet weak var newRecipeSteps: UITextView!
    @IBOutlet weak var newRecipeName: UITextField!
    
    var recipeService: RecipeService!
    var recipeDetails: RecipeModel?
    var recipeList: [RecipeModel]!
    var recipeType:[String] = []
    var currentUniqueId: Int?
    var imagePath: String?
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI For Recipe Details
        setupUI()
        
    }
    
    //Edit Recipe
    func saveRecipe(){
        indicatorProcessingView()
        if recipeDetails == nil{
            let recipe = RecipeModel()
            
            if newRecipeImg.image != nil {
                let imageName = "\(currentUniqueId! + 1)_\(newRecipeName.text)"
                imagePath = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageName).png"
                
                let imageUrl: URL = URL(fileURLWithPath: imagePath!)

                //Store Image
                try? newRecipeImg.image!.pngData()?.write(to: imageUrl)
                self.imageUrl = imagePath
            }
            
            recipe.name = newRecipeName.text ?? ""
            recipe.type = newRecipeType.text ?? ""
            recipe.ingredients = newRecipeIngredients.text ?? ""
            recipe.steps = newRecipeSteps.text ?? ""
            recipe.imageUrl = imagePath!
            recipeService.addRecipe(recipe)
            dismiss(animated: true, completion: nil)
            indicatorSuccessingDelay()
        }else{
            try? recipeService.realmManager.update {
                self.recipeDetails?.name = self.newRecipeName.text ?? ""
                self.recipeDetails?.type = self.newRecipeType.text ?? ""
                self.recipeDetails?.ingredients = self.newRecipeIngredients.text ?? ""
                self.recipeDetails?.steps = self.newRecipeSteps.text ?? ""
            }
            self.navigationController?.popViewController(animated: true)
        }
        delegate?.reloadRecipes()
    }
    
    // Delete Recipe
    func deleteRecipe(){
        recipeService.realmManager.delete(object: recipeDetails!)
        self.navigationController?.popViewController(animated: true)
        delegate?.reloadRecipes()
    }
}

