//
//  CRUDNewRecipeViewController.swift
//  RecipeAppExample
//
//  Created by Uri on 11/29/20.
//

import Foundation
import UIKit
import SDWebImage

protocol NewRecipeViewControllerDelegate: class {
    func reloadRecipes()
}

class NewRecipeViewController: UIViewController{    
    
    weak var delegate: NewRecipeViewControllerDelegate?
    
    @IBAction func recipeSave(_ sender: Any) {
        editRecipe()
    }
    @IBAction func recipeDelete(_ sender: Any) {
        deleteRecipe()
    }
    @IBAction func newRecipeCreate(_ sender: Any) {
        createNewRecipe()
    }
    
    @IBOutlet weak var newRecipeSteps: UITextView!
    @IBOutlet weak var newRecipeIngredients: UITextView!
    @IBOutlet weak var newRecipeType: UITextField!
    @IBOutlet weak var newRecipeName: UITextField!
    @IBOutlet weak var newRecipeImg: UIImageView!
    @IBOutlet var recipePickerView: UIPickerView!
    
    var recipeService: RecipeService!
    var recipeDetails: RecipeModel?
    var recipeList: [RecipeModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UI For Recipe Details
        setupUI()
        
    }
    
    //Edit Recipe
    func editRecipe(){
        if recipeDetails == nil{
            let recipe = RecipeModel()
            recipe.name = newRecipeName.text ?? ""
            recipe.type = newRecipeType.text ?? ""
            recipe.ingredients = newRecipeIngredients.text ?? ""
            recipe.steps = newRecipeSteps.text ?? ""
            dismiss(animated: true, completion: nil)
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
    
    //Create new Recipe
    func createNewRecipe(){
        let recipe = RecipeModel()
        recipe.name = newRecipeName.text ?? ""
        recipe.type = newRecipeType.text ?? ""
        recipe.ingredients = newRecipeIngredients.text ?? ""
        recipe.steps = newRecipeSteps.text ?? ""
        recipeService.addRecipe(recipe)
        dismiss(animated: true, completion: nil)
        delegate?.reloadRecipes()
    }
}

