//
//  MediaPlayCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/12/24.
//

import UIKit
import Kingfisher

final class MediaPlayCollectionViewCell: BaseCollectionViewCell {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        contentView.backgroundColor = .gray //MARK: 삭제 요망
        setHierarchy()
        setLayout()
    }
    
    override func setHierarchy() {
        addSubview(mediaImageView)
        addSubview(titleLabel)
        addSubview(playButton)
    }
    
    override func setLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalToSuperview().multipliedBy(0.82)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(playButton.snp.leading).offset(-16)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
    }
    
    func updateCell(title: String, image: UIImage) {
        titleLabel.text = title
        mediaImageView.image = image
    }
    
}

extension MediaPlayCollectionViewCell {
    func configure(with item: Result) {
        titleLabel.text = item.title
        
        if let imageUrlString = item.posterPath,
           let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrlString)") {
            DispatchQueue.main.async {
                self.mediaImageView.kf.setImage(with: imageUrl)
            }
        } else {
            mediaImageView.image = UIImage(named: "placeholder")
        }
    }
}
