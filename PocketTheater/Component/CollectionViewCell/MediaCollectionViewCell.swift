//
//  MediaCollectionViewCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import UIKit
import SnapKit
import Then

final class MediaCollectionViewCell: BaseCollectionViewCell {
    
    private let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    override func setHierarchy() {
        addSubview(mediaImageView)
    }
    
    override func setLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
