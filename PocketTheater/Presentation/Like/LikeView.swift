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
    
    /// `다음에 작업하는 사람이 지우고 작업해 주세요~!`
    private let testLabel = UILabel().then {
        $0.text = "좋아요 화면입니다."
        $0.textColor = Resource.Color.white
    }

    override func setHierarchy() {
        [testLabel].forEach { self.addSubview($0) }
    }
    
    override func setLayout() {
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
}
