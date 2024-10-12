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
        
        // 디테일 탭 임시 추가
        let detail = createTabBarItem(title: "Detail(임시)", image: Resource.Image.plus, viewController: DetailViewController())
        
        let viewControllers = [home, search, like, detail]
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
//        tabBar.barTintColor = .red
        tabBar.tintColor = Resource.Color.white
    }
    
}
