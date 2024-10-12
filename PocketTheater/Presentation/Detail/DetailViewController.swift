//
//  DetailViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/10/24.
//

import UIKit
import RxCocoa
import RxDataSources
import RxGesture
import RxSwift
import SnapKit

struct DetailDataSection {
    var header: UICollectionReusableView
    var items: [UIImage]  /// 수정 필요! `[Result]`
}

extension DetailDataSection: SectionModelType {
    typealias Item = UIImage /// 수정 필요! `Result`
    
    init(original: DetailDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class DetailViewController: BaseViewController {
    
    private let headerView = DetailHeaderView()
    private let detailView = DetailView()
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailDataSection>!
    
    private let testDummy = DetailDataSection(header: DetailHeaderView(), 
                                              items: [UIImage(), UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),UIImage()]) /// 수정 필요! `Result`
    
    private lazy var sectionSubject = BehaviorSubject(value: [testDummy])
    
    
    // 미디어 설명 레이블 (더보기 처리)
    private var isTapped = false
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // dataSource 초기화
        dataSource = DetailViewController.dataSource()
        // 헤더뷰 & 셀 등록
        detailView.similarCollectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        detailView.similarCollectionView.register(DetailHeaderView.self,
                    forSupplementaryViewOfKind: DetailHeaderView.elementKind,
                    withReuseIdentifier: DetailHeaderView.identifier)
    
        sectionSubject.onNext([testDummy])
        bind()
    }
    
    private func bind() {
        let input = DetailViewModel.Input()
        let _ = viewModel.transform(input: input)

        headerView.overviewLabel.rx.tapGesture()
            .when(.recognized)  /// tapGesture()를 그냥 사용 시, sampleView 바인딩 할 때 event가 emit되므로 해당 코드 추가
            .subscribe { [weak self] _ in
                print("설명 영역 탭했어요!")
                self?.toggleOverviewLabel()
            }
            .disposed(by: disposeBag)
        
        sectionSubject
            .bind(to: detailView.similarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func toggleOverviewLabel() {
        isTapped.toggle()
        headerView.overviewLabel.numberOfLines = isTapped ? 0 : 2
        
        UIView.animate(withDuration: 0.3) {
            self.headerView.layoutIfNeeded()
        }
    }
    
}

extension DetailViewController {
    static func dataSource() -> RxCollectionViewSectionedReloadDataSource<DetailDataSection> {
        return RxCollectionViewSectionedReloadDataSource<DetailDataSection>(
            configureCell: { dataSource, collectionView, indexPath, data in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return MediaCollectionViewCell() }
                Task {
                    do {
                        try await cell.updateCellTest(data)
                    } catch {
                        print("Error: ", error)
                    }
                }
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                if kind == UICollectionView.elementKindSectionHeader {
                    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderView.identifier, for: indexPath) as? DetailHeaderView else { return DetailHeaderView() }
                    // let section = dataSource.sectionModels[indexPath.section]
                    // header.overviewLabel.text = ""
                    header.updateHeaderView()
                    return header
                } else {
                    return UICollectionReusableView()
                }
            }
        )
    }
}
