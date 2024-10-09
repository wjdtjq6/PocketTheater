//
//  SearchViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import Foundation

class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        print("Init SearchViewController")
    }
    
    deinit {
        print("Deinit SearchViewController")
    }
    
}
