//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import Foundation
import SWXMLHash
import RxSwift

class RecipeService: RecipeServiceProtocol{
    
    func fetchRecipeData() -> Observable<[RecipeModel]> {
        var recipes = [RecipeModel]()
        let type: String = ""
        return Observable.create{ [self]observer -> Disposable in
            if type.isEmpty {
                if let results = realmManager.fetch(RecipeModel.self) {
                    recipes = Array(results)
                    observer.onNext(recipes)
                    return Disposables.create {
                    }
                }
            } else {
                if let results = realmManager.fetch(RecipeModel.self, predicate: NSPredicate(format: "type == %@", type)) {
                    recipes = Array(results)
                    observer.onNext(recipes)
                    return Disposables.create {
                    }
                }
            }
           // return recipes as! Disposable
           // return Disposable.create{}
            return Disposables.create {
            }
        }
    }
    
    var realmManager = DatabaseManager.shared
    
    func loadRecipes() {
        if let results = realmManager.fetch(RecipeModel.self), results.isEmpty {
            loadRecipesFromBundle()
        }
    }
    
    func fetchRecipes(of type: String = "") -> [RecipeModel] {
        var recipes = [RecipeModel]()
        if type.isEmpty {
            if let results = realmManager.fetch(RecipeModel.self) {
                recipes = Array(results)
            }
        } else {
            if let results = realmManager.fetch(RecipeModel.self, predicate: NSPredicate(format: "type == %@", type)) {
                recipes = Array(results)
            }
        }
        return recipes
    }

    func addRecipe(_ recipe: RecipeModel) {
        try? realmManager.create(RecipeModel.self, completion: { newRecipe in
            newRecipe.name        = recipe.name
            newRecipe.type        = recipe.type
            newRecipe.ingredients = recipe.ingredients
            newRecipe.steps       = recipe.steps
        })
    }
    
    
    //Load data from XML file
    private func loadRecipesFromBundle() {
        guard let path = Bundle.main.path(forResource: "recipes", ofType: "xml") else { return }
        let xmlContent = try! String(contentsOfFile: path)
        let xml = SWXMLHash.parse(xmlContent)
        
        for elem in xml["recipes"]["recipe"].all {
            
            let type = elem["type"].element!.text
            let name = elem["name"].element!.text
            let ingredients = elem["ingredients"].element!.text
            let steps = elem["steps"].element!.text
            let imageUrl = elem["image_url"].element!.text
            
            try? realmManager.create(RecipeModel.self) { recipe in
                recipe.name = name
                recipe.type = type
                recipe.ingredients = ingredients
                recipe.steps = steps
                recipe.imageUrl = imageUrl
            }
        }
    }
    
}
