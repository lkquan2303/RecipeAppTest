//
//  ViewController.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

class RecipeHomeViewController: UIViewController {
    
    @IBAction func recipeFilter(_ sender: Any) {
        recipeFilter()
    }
    @IBOutlet var recipeCategoryPicker: UIPickerView!
    @IBOutlet weak var recipeTableview: UITableView!
    @IBOutlet weak var recipeTextField: UITextField!
    
    var recipeList: [RecipeModel]!
    var recipeService = RecipeService()
    var listViewModel: RecipeListViewModel!
    let disposeBag = DisposeBag()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addNewRecipeVC = segue.destination as! NewRecipeViewController
        addNewRecipeVC.delegate = self
        addNewRecipeVC.recipeService = recipeService
        if segue.identifier == Strings.navigatorUpdate, let indexPath = recipeTableview.indexPathForSelectedRow{
            recipeTableview.deselectRow(at: indexPath, animated: true)
            addNewRecipeVC.recipeDetails = recipeList[indexPath.row]
            addNewRecipeVC.recipeList = recipeList
            getTypeRecipe()
        }else{
            getTypeRecipe()
        }
    }
    
    static func instantiate(viewModel: RecipeListViewModel) -> RecipeHomeViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateInitialViewController() as! RecipeHomeViewController
        viewController.listViewModel = viewModel
        return viewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.indicatorSuccessingView()
            PKHUD.sharedHUD.hide()
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
    //Button Recipe Filter
    func recipeFilter(){
        let type = recipeTextField.text ?? ""
        recipeList = recipeService.fetchRecipes(of: type)
        recipeTableview.reloadData()
        recipeTextField.resignFirstResponder()
        print("\(listViewModel.fetchRecipeViewModel())")
    }
    
    func getTypeRecipe(viewController: NewRecipeViewController = NewRecipeViewController()){
        for i in 0..<recipeList.count{
            viewController.recipeType.append(recipeList[i].type)
        }
    }
}

