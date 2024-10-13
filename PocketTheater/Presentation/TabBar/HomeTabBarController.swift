//
//  HomeTabBarController.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarUI()
    }
    
    func setDefaultTabBar() {
        let home = createTabBarItem(title: "Home", image: Resource.Image.house, viewController: HomeViewController())
        let search = createTabBarItem(title: "Top Search", image: Resource.Image.search, viewController: SearchViewController())
        let like = createTabBarItem(title: "Like", image: Resource.Image.smileFace, viewController: LikeViewController())
        
        let viewControllers = [home, search, like]
        self.setViewControllers(viewControllers, animated: true)
    }
    
    func setCustomTabBar(with viewControllers: [UIViewController]) {
        self.setViewControllers(viewControllers, animated: true)
    }
    
    func createTabBarItem(title: String, image: UIImage?, viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
        return navigationController
    }
    
    private func setTabBarUI() {
        tabBar.backgroundColor = Resource.Color.darkGray
<<<<<<< HEAD
        tabBar.barTintColor = Resource.Color.darkGray
=======
>>>>>>> de9f5b6 (Fix: navigationbar & tabbar 스크롤 시 색상 변경 문제 해결)
        tabBar.tintColor = Resource.Color.white
        tabBar.barTintColor = Resource.Color.darkGray
    }
    
}
