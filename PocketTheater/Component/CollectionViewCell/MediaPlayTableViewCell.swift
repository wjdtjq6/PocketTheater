//
//  MediaPlayTableViewCell.swift
//  PocketTheater
//
//  Created by junehee on 10/13/24.
//

import UIKit

final class MediaPlayTableViewCell: BaseTableViewCell {
    
    private let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .lightGray
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Resource.Color.white
        $0.text = "Dummy Text 입니다"
    }
    
    private let playButton = UIImageView().then {
        $0.image = Resource.Image.playCircle
        $0.contentMode = .scaleAspectFill
        $0.tintColor = Resource.Color.white
    }
    
    override func setHierarchy() {
        addSubview(mediaImageView)
        addSubview(titleLabel)
        addSubview(playButton)
    }
    
    override func setLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(playButton.snp.leading).offset(-16)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(60)
        }
    }
    
    func updateCell(item: LikeDataSection.Item) {
        titleLabel.text = item.title
        mediaImageView.image = item.image
    }
    
}

