//
//  FeaturedCollectionViewCell.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/13/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class FeaturedCollectionViewCell: UICollectionViewCell {
    
    let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    let genreLabel = UILabel().then {
        $0.textColor = .white
        $0.font = Resource.Font.bold13
        $0.textAlignment = .center
    }
    
    let gradientOverlay = UIView()
    
    let playButton = ActionButton(mode: .play, fontSize: 12)
    let myListButton = ActionButton(mode: .myList, fontSize: 12)
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpLayout()
        setupGradientOverlay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
        contentView.addSubview(mediaImageView)
        contentView.addSubview(gradientOverlay)
        contentView.addSubview(genreLabel)
        contentView.addSubview(playButton)
        contentView.addSubview(myListButton)
    }
    
    private func setUpLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        gradientOverlay.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        genreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-60)
            make.height.equalTo(28)
        }
        
        playButton.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(20)
            make.bottom.equalTo(contentView).offset(-20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.height.equalTo(30)
        }
        
        myListButton.snp.makeConstraints { make in
            make.right.equalTo(contentView).offset(-20)
            make.bottom.equalTo(contentView).offset(-20)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.4)
            make.height.equalTo(30)
        }
    }
    
    private func setupGradientOverlay() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, Resource.Color.darkGray.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.cornerRadius = 20
        gradientOverlay.layer.addSublayer(gradientLayer)
        
        gradientOverlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientOverlay.layoutIfNeeded()
        gradientLayer.frame = gradientOverlay.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientOverlay.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientOverlay.bounds
        }
    }
    
    func configure(with genre: String) {
        genreLabel.text = "  \(genre)  "
        genreLabel.isHidden = false // 장르 정보가 있을 때만 보이도록 설정
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        mediaImageView.image = nil
        genreLabel.text = nil
        genreLabel.isHidden = true // 재사용 시 숨김 처리
    }
}
