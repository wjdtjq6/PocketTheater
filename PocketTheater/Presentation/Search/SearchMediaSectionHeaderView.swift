//
//  SearchMediaSectionHeaderView.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/12/24.
//

import UIKit

class MediaSectionHeaderView: UICollectionReusableView {
    
    private let titleLabel = UILabel().then {
        $0.font = Resource.Font.bold18
        $0.textColor = Resource.Color.white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}
