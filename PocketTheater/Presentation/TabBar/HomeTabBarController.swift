//
//  HomeTabBar.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

final class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setTabBarUI()
    }
    
    func setDefaultTabBar() {
//        let home = createTabBarItem(title: "홈", image: Resource.Image.home, viewController: HomeViewController())
//        let search = createTabBarItem(title: "해시태그", image: Resource.Image.hashtag, viewController: HashTagViewController())
//        let community = createTabBarItem(title: "커뮤니티", image: Resource.Image.board, viewController: CommunityViewController())
//        let mypage = createTabBarItem(title: "마이페이지", image: Resource.Image.person, viewController: MyPageViewController())
//        
//        let viewControllers = [home, search, community, mypage]
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
    
//    private func setTabBarUI() {
//        tabBar.backgroundColor = Resource.Color.paleGray
//        tabBar.layer.borderWidth = 1
//        tabBar.layer.borderColor = Resource.Color.lightGray.cgColor
//        tabBar.tintColor = Resource.Color.purple
//    }
//    
}
