//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import Foundation

struct RecipeViewModel{
    
    private let recipe: RecipeModel
    
    var displayRecipeName: String{
        return recipe.type
    }
    
    var displayRecipeImage: String{
        return recipe.imageUrl
    }
    
    var displayRecipeIngredient: String{
        return recipe.ingredients
    }
    
    var displayRecipeStep: String{
        return recipe.steps
    }
    
    var getRecipeDetails: RecipeModel{
        return recipe
    }
    
    init(recipe: RecipeModel) {
        self.recipe = recipe
    }
}
