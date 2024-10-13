//
//  BaseViewController.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Resource.Color.black
        setViewController()
    }
    
    //MARK: ex) navigationTitle
    func setViewController() {
        navigationController?.navigationBar.barTintColor = Resource.Color.darkGray
<<<<<<< HEAD
<<<<<<< HEAD
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
=======
        tabBarController?.tabBar.barTintColor = Resource.Color.darkGray
>>>>>>> de9f5b6 (Fix: navigationbar & tabbar 스크롤 시 색상 변경 문제 해결)
=======
>>>>>>> 83cef02 (Feat: 홈 화면 메인 미디어 레이아웃 수정, ViewModel 타입 추가, NavigationBar 추가")
    }
    
}
