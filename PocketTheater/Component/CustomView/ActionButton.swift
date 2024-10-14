//
//  ActionButton.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/9/24.
//

import UIKit

//MARK: 재생, 내가찜한 리스트, 저장 버튼
final class ActionButton: UIButton {
    
    enum ButtonMode {
        case play // 홈뷰, 디테일뷰에서 사용
        case myList // 홈뷰에서 사용
        case save // 디테일뷰에서 사용
    }
    
    init(mode: ButtonMode, fontSize: CGFloat = 14) {
        super.init(frame: .zero)
        configureButton(for: mode, fontSize: fontSize)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(for mode: ButtonMode, fontSize: CGFloat?) {
        var config = UIButton.Configuration.filled()
        var image: UIImage?

        switch mode {
        case .play:
            config.title = "재생"
            image = Resource.Image.play
            
            config.baseBackgroundColor = Resource.Color.white
            config.baseForegroundColor = Resource.Color.black
            
        case .myList:
            config.title = "내가 찜한 리스트"
            image = Resource.Image.plus
            
            config.baseBackgroundColor = Resource.Color.black
            config.baseForegroundColor = Resource.Color.white
            
        case .save:
            config.title = "저장"
            image = Resource.Image.download
            
            config.baseBackgroundColor = Resource.Color.darkGray
            config.baseForegroundColor = Resource.Color.white
        }
        
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.cornerStyle = .medium
        
        if let fontSize = fontSize {
            // 폰트 크기 적용
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
                var updatedAttributes = attributes
                updatedAttributes.font = UIFont.systemFont(ofSize: fontSize)
                return updatedAttributes
            }
            
            // 이미지도 타이틀 크기과 맞춤
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: fontSize, weight: .medium)
            config.image = image?.withConfiguration(symbolConfig)
        } else {
            // 폰트 크기 미지정 시 기본 이미지 설정
            config.image = image
        }
        
        self.configuration = config
    }
}
