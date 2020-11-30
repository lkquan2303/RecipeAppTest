//
//  ViewController.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import UIKit

class RecipeHomeViewController: UIViewController {

    @IBAction func recipeFilter(_ sender: Any) {
    }
    @IBOutlet weak var recipeTextField: UITextField!
    @IBOutlet var recipeCategoryPicker: UIPickerView!
    @IBOutlet weak var recipeTableview: UITableView!
    
    var recipeList: [RecipeModel]!
    var recipeService = RecipeService()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addNewRecipeVC = segue.destination as! NewRecipeViewController
        addNewRecipeVC.delegate = self
        addNewRecipeVC.recipeService = recipeService
        if segue.identifier == Strings.navigatorUpdate, let indexPath = recipeTableview.indexPathForSelectedRow{
            addNewRecipeVC.recipeDetails = recipeList[indexPath.row]
            recipeTableview.deselectRow(at: indexPath, animated: true)
            
            addNewRecipeVC.recipeList = recipeList
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
}

