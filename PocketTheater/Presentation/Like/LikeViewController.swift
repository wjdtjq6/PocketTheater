//
//  LikeViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

struct LikeDataSection {
    var header: String
    var items: [Like]
}

extension LikeDataSection: SectionModelType {
    typealias Item = Like
    
    init(original: LikeDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class LikeViewController: BaseViewController {
    
    private let likeView = LikeView()
    private let viewModel = LikeViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<LikeDataSection>!
    
    /// 테스트용 더미 데이터
    // private var items = BehaviorSubject<[SomeType.Model]>(
    //     value: [
    //       SomeType.Model(
    //         model: .date(date: Date()),
    //         items: (0...100)
    //           .map(String.init)
    //           .map { SomeType.Model.Item.record(title: $0) }
    //       )
    //     ]
    //   )
    
    override func loadView() {
        view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constant.Like.navigationTitle
        dataSource = LikeViewController.dataSource()
        bind()
    }
    
    deinit {
        print("Deinit LikeViewController")
    }
    
    private func bind() {
        let input = LikeViewModel.Input()
        let _ = viewModel.transform(input: input)
       
    }
    
}

extension LikeViewController {
    static func dataSource() -> RxCollectionViewSectionedReloadDataSource<LikeDataSection> {
        return RxCollectionViewSectionedReloadDataSource<LikeDataSection>(
            configureCell: { dataSource, collectionView, indexPath, data in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else { return MediaCollectionViewCell() }
                
                return cell
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaSectionHeaderView.identifier, for: indexPath) as! MediaSectionHeaderView
                let section = dataSource[indexPath.section]
                header.configure(with: section.header)
                return header
            }

        )
    }
}
