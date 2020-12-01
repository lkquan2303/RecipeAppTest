//
//  RecipeModel.swift
//  RecipeApp
//
//  Created by Uri on 11/30/20.
//

import Foundation
import RealmSwift

class RecipeModel: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var ingredients = ""
    @objc dynamic var steps = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var type = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
