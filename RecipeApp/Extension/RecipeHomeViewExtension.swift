//
//  RecipeHomeViewExtension.swift
//  RecipeAppExample
//
//  Created by Uri on 11/30/20.
//

import Foundation
import UIKit
import SDWebImage
import PKHUD
import Photos
import MobileCoreServices

//MARK: HomeScreen Extension

///Extension Picker
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

///Extension Textfield
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

//Setup Tableview
extension RecipeHomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.tableCellId, for: indexPath) as! RecipeTableViewCell
        // let recipe = recipeList[indexPath.row]
        //    cell.recipeName.text = recipe.name
        // cell.recipeImage.sd_setImage(with: URL(string: recipe.imageUrl), completed: nil)
        //    cell.recipeImage.image = load(fileName: recipe.imageUrl)
        cell.setUpCellView(recipeDetails: recipeList[indexPath.row])
        return cell
    }
}

extension RecipeHomeViewController: NewRecipeViewControllerDelegate{
    func reloadRecipes() {
        recipeList = recipeService.fetchRecipes()
        recipeTableview.reloadData()
    }
}

//MARK: New Recipe Screen Extension
/// New Recipe Setup View
extension NewRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func setupUI(){
        if let recipe = recipeDetails{
            navigationBar.isHidden = true
            topLayoutConstraint.constant = 8
            newRecipeName.text = recipe.name
            newRecipeType.text = recipe.type
            newRecipeIngredients.text = recipe.ingredients
            newRecipeSteps.text = recipe.steps
            
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
            let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath   = paths.first
            {
                let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(recipe.imageUrl)")
                let image    = UIImage(contentsOfFile: imageURL.path)
                newRecipeImg.image = image
            }
        }
        
        newRecipeType.inputView = recipePickerView
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newRecipeType.text = recipeType[row]
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    /// Open Gallery
    func openGallery() {
        PHPhotoLibrary.requestAuthorization({ status in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    //Display permission has not granted to open Photos library
                }
            }
        })
    }
    
    /// Image picker controller only for gallery.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Dismiss image picker
        imagePicker.dismiss(animated: true, completion: nil)
        if let originalImage = info[.originalImage] as? UIImage {
            newRecipeImg.image = originalImage
        }
    }
}

//MARK: Indicator View Setup
extension UIViewController{
    
    func indicatorSuccessingView(){
        PKHUD.sharedHUD.contentView = PKHUDSuccessView(title: "Success")
        PKHUD.sharedHUD.show()
    }
    
    func indicatorProcessingView(){
        PKHUD.sharedHUD.contentView = PKHUDProgressView(title: "Processing")
        PKHUD.sharedHUD.show()
    }
    
    func indicatorSuccessingDelay(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicatorSuccessingView()
            PKHUD.sharedHUD.hide()
        }
    }
}
