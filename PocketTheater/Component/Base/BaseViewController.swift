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
    func setViewController() { }
    
}
