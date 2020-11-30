//
//  RecipeHomeViewExtension.swift
//  RecipeAppExample
//
//  Created by Uri on 11/30/20.
//

import Foundation
import UIKit
import SDWebImage

//Extension Picker
extension RecipeHomeViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeList[row].type
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recipeTextField.text = recipeList[row].type
    }
}

//Extension Textfield
extension RecipeHomeViewController: UITextFieldDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        recipeTextField.text = ""
        recipeTextField.resignFirstResponder()
        recipeFilter()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if recipeTextField.text?.isEmpty ?? false{
            recipeTextField.text = recipeList[0].type
            recipeCategoryPicker.selectRow(0, inComponent: 0, animated: true)
        }else{
            let name = recipeTextField.text ?? ""
            let index = recipeList.firstIndex(where: {$0.type == name}) ?? 0
            recipeCategoryPicker.selectRow(index, inComponent: 0, animated: true)
        }
    }
}

//Extension Tableview
extension RecipeHomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.tableCellId, for: indexPath) as! RecipeTableViewCell
        let recipe = recipeList[indexPath.row]
        cell.recipeName.text = recipe.name
        cell.recipeImage.sd_setImage(with: URL(string: recipe.imageUrl), completed: nil)
        return cell
    }
}

extension RecipeHomeViewController: NewRecipeViewControllerDelegate{
    func reloadRecipes() {
        recipeList = recipeService.fetchRecipes()
        recipeTableview.reloadData()
    }
}


// New Recipe Setup View
extension NewRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func setupUI(){
        if let recipe = recipeDetails{
        newRecipeName.text = recipe.name
        newRecipeType.text = recipe.type
        newRecipeIngredients.text = recipe.ingredients
        newRecipeSteps.text = recipe.steps
        newRecipeImg.sd_setImage(with: URL(string: recipe.imageUrl), completed: nil)
        }
        newRecipeType.inputView = recipePickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeList[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newRecipeType.text = recipeList[row].name
    }
}
