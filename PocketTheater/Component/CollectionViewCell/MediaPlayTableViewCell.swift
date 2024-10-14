//
//  MediaPlayTableViewCell.swift
//  PocketTheater
//
//  Created by junehee on 10/13/24.
//

import UIKit
import SnapKit
import Then

final class MediaPlayTableViewCell: BaseTableViewCell {
    
    private let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = Resource.Color.white
        $0.font = Resource.Font.bold16
        $0.numberOfLines = 2
    }
    
    private let playButton = UIImageView().then {
        $0.image = Resource.Image.playCircle
        $0.contentMode = .scaleAspectFit
        $0.tintColor = Resource.Color.white
    }
    
    override func setHierarchy() {
        [mediaImageView, titleLabel, playButton].forEach { contentView.addSubview($0) }
        contentView.backgroundColor = Resource.Color.black
    }
    
    override func setLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(100)
            make.height.equalTo(150)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mediaImageView.snp.trailing).offset(16)
            make.centerY.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(playButton.snp.leading).offset(-8)
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(40)
        }
    }
    
    func updateCell(item: Like) {
        titleLabel.text = item.title
        
        loadImage(from: item.imagePath)
    }
    
    private func loadImage(from path: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            if let image = UIImage(contentsOfFile: path) {
                mediaImageView.image = image
            } else {
                mediaImageView.image = UIImage(named: "placeholder_image")
            }
        } else {
            mediaImageView.image = UIImage(named: "placeholder_image")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaImageView.image = nil
        titleLabel.text = nil
    }
}
