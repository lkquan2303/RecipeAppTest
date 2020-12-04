//
//  RecipeListViewModel.swift
//  Recipe-App
//
//  Created by Uri on 11/27/20.
//

import Foundation
import RxSwift

final class RecipeListViewModel{
    
    private let recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol = RecipeService()) {
        self.recipeService = recipeService
    }
    
    func fetchRecipeViewModel() -> Observable<[RecipeViewModel]> {
        recipeService.fetchRecipeData().map {$0.map{RecipeViewModel(recipe: $0)}}
    }
}
