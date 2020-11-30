//
//  AppCoordinator.swift
//  Recipe-App
//
//  Created by Uri on 11/27/20.
//

import Foundation
import UIKit
class AppCoordinator{
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let homeViewController = RecipeHomeViewController.instantiate(viewModel: RecipeListViewModel())
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
}
