//
//  RecipeServiceProtocol.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import Foundation
import RxSwift

protocol RecipeServiceProtocol {
    func fetchRecipeData() -> Observable<[RecipeModel]>
}

protocol NewRecipeViewControllerDelegate: class {
    func reloadRecipes()
}
