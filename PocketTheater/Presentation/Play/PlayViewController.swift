//
//  PlayViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/12/24.
//

import UIKit

final class PlayViewController: BaseViewController {
    
    private let playView = PlayView()
    
    override func loadView() {
        view = playView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Init PlayViewController")
    }
    
}
