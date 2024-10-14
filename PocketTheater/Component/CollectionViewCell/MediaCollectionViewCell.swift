//
//  MediaCollectionViewCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class MediaCollectionViewCell: BaseCollectionViewCell {

    let disposeBag = DisposeBag()
    let mediaImageView = UIImageView().then {
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
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}

extension MediaCollectionViewCell {
    func configure(with item: Result) {
        print("🍀🍀")
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
