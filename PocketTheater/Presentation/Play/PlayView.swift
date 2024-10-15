//
//  PlayView.swift
//  PocketTheater
//
//  Created by junehee on 10/12/24.
//

import WebKit
import SnapKit

final class PlayView: BaseView {
    
    private let webView = WKWebView()
    
    override func setHierarchy() {
        self.addSubview(webView)
    }
    
    override func setLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
