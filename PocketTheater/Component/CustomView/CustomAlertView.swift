//
//  CustomAlertView.swift
//  PocketTheater
//
//  Created by 소정섭 on 10/14/24.
//

import UIKit
import SnapKit

class CustomAlertView: UIView {
    private let messageLabel = UILabel()
    private let confirmButton = UIButton()
    
    var onConfirm: (() -> Void)?
    
    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(message: String) {
        backgroundColor = Resource.Color.black.withAlphaComponent(0.8)
        layer.cornerRadius = 8
        
        messageLabel.text = message
        messageLabel.textColor = Resource.Color.white
        messageLabel.font = Resource.Font.regular16
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        addSubview(messageLabel)
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = Resource.Color.red
        confirmButton.layer.cornerRadius = 4
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        addSubview(confirmButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
    }
    
    @objc private func confirmTapped() {
        removeFromSuperview()
        onConfirm?()
    }
}
