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
  
//        let fileName = "https://www.cookiemadness.net/wp-content/uploads/2018/01/sandyschocolatecake.jpg"
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + fileName
//        let image = UIImage(contentsOfFile: path)
//        newRecipeImg.image = image
        
        openGallery()
        
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
    
    var imagePicker =  UIImagePickerController()
    var recipeService: RecipeService!
    var recipeDetails: RecipeModel?
    var recipeList: [RecipeModel]!
    var recipeType:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI For Recipe Details
        setupUI()
        
    }
    
    //Edit Recipe
    func saveRecipe(){
       // indicatorProcessingView()
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
                        print("\(fileURL)")
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
        //indicatorSuccessingDelay()
    }
    
    // Delete Recipe
    func deleteRecipe(){
        indicatorProcessingView()
        recipeService.realmManager.delete(object: recipeDetails!)
        self.navigationController?.popViewController(animated: true)
        delegate?.reloadRecipes()
    }
}

