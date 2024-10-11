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

final class DetailViewController: BaseViewController {
    
    private enum DetailSection: CaseIterable {
        case similar
    }
    
    private let detailView = DetailView()
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    // private var dataSource: UICollectionViewDiffableDataSource<DetailSection, Result>!
    private var dataSource: UICollectionViewDiffableDataSource<DetailSection, UIImage>!
    
    // 미디어 설명 레이블 (더보기 처리)
    private var isTapped = false
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureDataSource()
        updateSnapshot()
    }
    
    private func bind() {
        let input = DetailViewModel.Input()
        let _ = viewModel.transform(input: input)

        detailView.overviewLabel.rx.tapGesture()
            .when(.recognized)  /// tapGesture()를 그냥 사용 시, sampleView 바인딩 할 때 event가 emit되므로 해당 코드 추가
            .subscribe { [weak self] _ in
                print("설명 영역 탭했어요!")
                self?.toggleOverviewLabel()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCellRegistration() -> UICollectionView.CellRegistration<MediaCollectionViewCell, UIImage> {
        return UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            Task {
                do {
                    // try await cell.updateCell(itemIdentifier)
                    try await cell.updateCellTest(itemIdentifier)
                } catch {
                    print("Failed to update cell: \(error)")
                }
            }
        }
    }
    
    private func configureDataSource() {
        let cellRegistration = configureCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: detailView.searchCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier)
            return cell
        })
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection, UIImage>()
        snapshot.appendSections(DetailSection.allCases)
        snapshot.appendItems([Resource.Image.download!], toSection: .similar)
        dataSource.applySnapshotUsingReloadData(snapshot)
    }

    private func toggleOverviewLabel() {
        isTapped.toggle()
        detailView.overviewLabel.numberOfLines = isTapped ? 0 : 2
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}
