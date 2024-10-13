//
//  HomeCollectionViewCell.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/11/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class HomeCollectionViewCell: UICollectionViewCell {
    
    let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
        contentView.addSubview(mediaImageView)
    }
    
    private func setUpLayout() {
        mediaImageView.snp.makeConstraints { make in
<<<<<<< HEAD
            make.edges.equalTo(contentView)
=======
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width).multipliedBy(1.5)
>>>>>>> ddcc5a5eb0b761f4e0bc0b12cc508d4d47332407
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        mediaImageView.image = nil
    }
<<<<<<< HEAD
=======
    
    func configure(with item: MediaItem) {
    }
>>>>>>> ddcc5a5eb0b761f4e0bc0b12cc508d4d47332407
}
