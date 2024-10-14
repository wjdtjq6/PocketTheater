//
//  DetailView.swift
//  PocketTheater
//
//  Created by junehee on 10/10/24.
//

import UIKit
import SnapKit
import Then

class DetailView: BaseView {
    
    // 상단 대표 이미지
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        // 임시 이미지 영역 확인용
        $0.backgroundColor = .red
    }
    
    // 비슷한 콘텐츠 컬렉션뷰
    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
        $0.backgroundColor = Resource.Color.black
        
        // 헤더 & 셀 등록
        $0.register(DetailHeaderCell.self, forCellWithReuseIdentifier: DetailHeaderCell.identifier)
        $0.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
    }
    
    private let tvButton = UIButton().then {
        $0.setImage(Resource.Image.tv, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.tintColor = Resource.Color.white
        $0.backgroundColor = Resource.Color.darkGray
        $0.layer.cornerRadius = 16
    }
    
    let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.tintColor = Resource.Color.white
        $0.backgroundColor = Resource.Color.darkGray
        $0.layer.cornerRadius = 16
    }
    
    override func setHierarchy() {
        self.addSubview(imageView)
        self.addSubview(similarCollectionView)
        self.addSubview(closeButton)
        self.addSubview(tvButton)
    }
    
    override func setLayout() {
        let safeArea = self.safeAreaLayoutGuide
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.horizontalEdges.equalTo(safeArea)
            make.height.equalTo(200)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeArea)
        }
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(16)
            make.trailing.equalTo(safeArea).inset(16)
            make.size.equalTo(32)
        }
        
        tvButton.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(16)
            make.trailing.equalTo(closeButton.snp.leading).offset(-16)
            make.size.equalTo(32)
        }
    }
    func updateDetailMainImage(_ path: String?) {
        print("🍀🍀")
        guard let path = path else { return }
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500\(path)") {
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: imageUrl)
            }
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}

