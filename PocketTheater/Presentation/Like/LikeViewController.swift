//
//  LikeViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import Foundation

class LikeViewController: BaseViewController {

    private let likeView = LikeView()
    
    override func loadView() {
        view = likeView
    }
    
    override func viewDidLoad() {
        print("Init LikeViewController")
    }
    
    deinit {
        print("Deinit LikeViewController")
    }
    
}
