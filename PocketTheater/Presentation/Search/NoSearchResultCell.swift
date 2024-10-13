//
//  NoSearchResultCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/13/24.
//

import UIKit

class NoResultsCell: UICollectionViewCell {

    private let messageLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다."
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
