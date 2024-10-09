//
//  BaseView.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setLayout()
    }
    
    //MARK: 화면 계층 구조 함수
    func setHierarchy() { }
    
    //MARK: 화면 레이아웃
    func setLayout() { }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
