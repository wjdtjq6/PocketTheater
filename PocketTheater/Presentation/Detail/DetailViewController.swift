//
//  DetailViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/10/24.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit

class DetailViewController: BaseViewController {
    
    private let detailView = DetailView()
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    // 미디어 설명 레이블 (더보기 처리)
    private var isTapped = false
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let input = DetailViewModel.Input()
        // let output = viewModel.transform(input: input)

        detailView.overviewLabel.rx.tapGesture()
            .when(.recognized)  /// tapGesture()를 그냥 사용 시, sampleView 바인딩 할 때 event가 emit되므로 해당 코드 추가
            .subscribe { [weak self] _ in
                print("설명 영역 탭했어요!")
                self?.toggleOverviewLabel()
            }
            .disposed(by: disposeBag)
    }

    private func toggleOverviewLabel() {
        isTapped.toggle()
        detailView.overviewLabel.numberOfLines = isTapped ? 0 : 2
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
