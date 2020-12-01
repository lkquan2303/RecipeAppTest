//
//  CRUDNewRecipeViewController.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import Foundation
import UIKit
import SDWebImage

class NewRecipeViewController: UIViewController{    
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var recipePickerView: UIPickerView!
    @IBOutlet weak var newRecipeImg: UIImageView!
    @IBOutlet weak var newRecipeType: UITextField!
    @IBOutlet weak var newRecipeIngredients: UITextView!
    @IBOutlet weak var newRecipeSteps: UITextView!
    @IBOutlet weak var newRecipeName: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var recipeSave: UIButton!
    
    var imagePicker =  UIImagePickerController()
    var recipeService: RecipeService!
    var recipeDetails: RecipeModel?
    var recipeList: [RecipeModel]!
    var recipeType:[String] = ["Vegetarian", "Fast Food", "BreakFast"]
    weak var delegate: NewRecipeViewControllerDelegate?
    
    
    //Button Handle
    @IBAction func recipeDelete(_ sender: Any) {
        deleteRecipe()
    }
    
    @IBAction func recipeSave(_ sender: Any) {
        if availableRecipe(){
            saveRecipe()
        }else{
            let alert = UIAlertController(title: Strings.error, message: Strings.warningRecipe, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Strings.okAction, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func recipeChangePhoto(_ sender: Any) {
        openGallery()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI For Recipe Details
        setupUI()
    }
    
    //Edit Recipe
    func saveRecipe(){
        if recipeDetails == nil{
            let recipe = RecipeModel()
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = "\(UUID().uuidString)img.jpg"
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            if let data = newRecipeImg.image!.jpegData(compressionQuality:  1.0),
               !FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    // writes the image data to disk
                    try data.write(to: fileURL)
                    print("Saved Image")
                } catch {
                    print("Error:", error)
                }
            }
            recipe.imageUrl = fileName
            recipe.name = newRecipeName.text ?? ""
            recipe.type = newRecipeType.text ?? ""
            recipe.ingredients = newRecipeIngredients.text ?? ""
            recipe.steps = newRecipeSteps.text ?? ""
            recipeService.addRecipe(recipe)
            dismiss(animated: true, completion: nil)
            delegate?.reloadRecipes()
        }else{
            try? recipeService.realmManager.update { [self] in
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileName = "\(UUID().uuidString)img.jpg"
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                if let data = newRecipeImg.image!.jpegData(compressionQuality:  1.0),
                   !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // writes the image data to disk
                        try data.write(to: fileURL)
                        print("Saved Image")
                    } catch {
                        print("Error:", error)
                    }
                }
                self.recipeDetails?.imageUrl = fileName
                self.recipeDetails?.name = self.newRecipeName.text ?? ""
                self.recipeDetails?.type = self.newRecipeType.text ?? ""
                self.recipeDetails?.ingredients = self.newRecipeIngredients.text ?? ""
                self.recipeDetails?.steps = self.newRecipeSteps.text ?? ""
            }
            self.navigationController?.popViewController(animated: true)
        }
        
        delegate?.reloadRecipes()
        indicatorSuccessingDelay()
    }
    
    // Delete Recipe
    func deleteRecipe(){
        indicatorProcessingView()
        recipeService.realmManager.delete(object: recipeDetails!)
        self.navigationController?.popViewController(animated: true)
        delegate?.reloadRecipes()
    }
    
    //Handle Availble Recipe
    func availableRecipe() -> Bool{
        if newRecipeName.text != "" && newRecipeSteps.text != "" && newRecipeIngredients.text != "" && newRecipeType.text != "" && newRecipeImg.image?.size.width != 0{
            return true
        }
        return false
    }
}

