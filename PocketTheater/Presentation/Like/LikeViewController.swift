//
//  LikeViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift

class LikeViewController: BaseViewController {

    // private let likeView = LikeView()
    private let detailView = DetailView()
    
    override func loadView() {
        // view = likeView
        view = detailView
    }
    
    override func viewDidLoad() {
        print("Init LikeViewController")
    }
    
    deinit {
        print("Deinit LikeViewController")
    }
    
}
