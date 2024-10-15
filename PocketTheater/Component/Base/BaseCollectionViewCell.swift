//
//  BaseCollectionViewCell.swift
//  PocketTheater
//
//  Created by junehee on 10/11/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() { }
    
    func setLayout() { }
    
}
