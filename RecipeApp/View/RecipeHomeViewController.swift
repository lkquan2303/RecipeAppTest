//
//  ViewController.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import UIKit

class RecipeHomeViewController: UIViewController {
    
    @IBOutlet var recipeCategoryPicker: UIPickerView!
    @IBOutlet weak var recipeTableview: UITableView!
    @IBAction func recipeFilter(_ sender: Any) {
        recipeFilter()
    }
    @IBOutlet weak var recipeTextField: UITextField!
    
    var recipeList: [RecipeModel]!
    var recipeService = RecipeService()
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addNewRecipeVC = segue.destination as! NewRecipeViewController
        addNewRecipeVC.delegate = self
        addNewRecipeVC.recipeService = recipeService
        if segue.identifier == Strings.navigatorUpdate, let indexPath = recipeTableview.indexPathForSelectedRow{
            recipeTableview.deselectRow(at: indexPath, animated: true)
            addNewRecipeVC.recipeDetails = recipeList[indexPath.row]
            addNewRecipeVC.recipeList = recipeList
            getTypeRecipe(viewController: addNewRecipeVC)
        }else{
            getTypeRecipe(viewController: addNewRecipeVC)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Setup View
        recipeTextField.inputView = recipeCategoryPicker
        recipeService.loadRecipes()
        recipeList = recipeService.fetchRecipes()
        
        //Setup Table View
        recipeTableview.tableFooterView = UIView()
        recipeTableview.register(RecipeTableViewCell.self, forCellReuseIdentifier: Strings.cellRecipeID)
        recipeTableview.contentInsetAdjustmentBehavior = .never
        
    }

    func recipeFilter(){
        let type = recipeTextField.text ?? ""
        recipeList = recipeService.fetchRecipes(of: type)
        recipeTableview.reloadData()
        recipeTextField.resignFirstResponder()
    }
    
    func getTypeRecipe(viewController: NewRecipeViewController){
        for i in 0..<recipeList.count{
            viewController.recipeType.append(recipeList[i].type)
        }
    }
}

