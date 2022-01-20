//
//  TabBarViewController.swift
//  CatApp
//
//  Created by Tomashchik Daniil on 19/01/2022.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    //MARK: - Private properties
    private let allPhotosVC = AllPhotosViewController()
    private let favoriteVC = FavoriteViewController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

private extension TabBarViewController {
    //MARK: - Private methods
    func commonInit() {
        allPhotosVC.title = Constants.allVCTitle
        favoriteVC.title = Constants.favoriteVCTitle
        
        allPhotosVC.navigationItem.largeTitleDisplayMode = .always
        favoriteVC.navigationItem.largeTitleDisplayMode = .always
        
        let allNavigationController = UINavigationController(rootViewController: allPhotosVC)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteVC)
        
        allNavigationController.navigationBar.tintColor = .label
        favoriteNavigationController.navigationBar.tintColor = .label
        
        allNavigationController.tabBarItem = UITabBarItem(title: Constants.allVCTitle, image: UIImage(systemName: Constants.allVCImageNmae), tag: 1)
        favoriteNavigationController.tabBarItem = UITabBarItem(title: Constants.favoriteVCTitle, image: UIImage(systemName: Constants.favoriteVCImageNmae), tag: 1)
        
        allNavigationController.navigationBar.prefersLargeTitles = true
        favoriteNavigationController.navigationBar.prefersLargeTitles = true
        
        setViewControllers([allNavigationController,favoriteNavigationController], animated: false)
    }
}

private extension TabBarViewController {
    //MARK: - Constants
    struct Constants {
        static let allVCTitle = "All photos"
        static let allVCImageNmae = "newspaper"
        static let favoriteVCTitle = "Favorites photos"
        static let favoriteVCImageNmae = "star.fill"
    }
}
