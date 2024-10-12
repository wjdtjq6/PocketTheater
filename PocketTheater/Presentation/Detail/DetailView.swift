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
    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Resource.CollectionViewLayout.detailViewLayout()).then {
        $0.backgroundColor = Resource.Color.black
        
        // 헤더 & 셀 등록
        $0.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        $0.register(DetailHeaderView.self,
                    forSupplementaryViewOfKind: DetailHeaderView.elementKind,
                    withReuseIdentifier: DetailHeaderView.identifier)
    }
    
    override func setHierarchy() {
        self.addSubview(imageView)
        self.addSubview(similarCollectionView)
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
    }
    
}

