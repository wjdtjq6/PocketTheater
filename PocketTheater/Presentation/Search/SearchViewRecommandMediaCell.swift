//
//  SearchViewRecommandMediaCell.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/10/24.
//

import UIKit

class SearchViewRecommandMediaCell: UICollectionViewCell {
    private let mediaImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Resource.Color.darkGray
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setUpHierarchy()
        setUpLayout()
    }
    
    func setUpHierarchy() {
        addSubview(mediaImageView)
    }
    func setUpLayout() {
        mediaImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
