//
//  HomeViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import Foundation

class HomeViewController: BaseViewController {
    
    private let homeView = HomeView()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        print("Init HomeViewController")
    }
    
    deinit {
        print("Deinit HomeViewController")
    }
    
}
