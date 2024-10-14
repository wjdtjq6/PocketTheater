//
//  LikeView.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import SnapKit
import Then

class LikeView: BaseView {
    
    let likeTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.allowsSelection = true
        $0.bounces = true
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.translatesAutoresizingMaskIntoConstraints = false
        // 셀 등록
        $0.register(MediaPlayTableViewCell.self, forCellReuseIdentifier: MediaPlayTableViewCell.identifier)
    }
    
    override func setHierarchy() {
        [likeTableView].forEach { self.addSubview($0) }
    }
    
    override func setLayout() {
        likeTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
}
