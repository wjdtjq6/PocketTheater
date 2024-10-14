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

struct MediaDetail {
    let movie: Result
    let cast: [String]
    let crew: [String]
    let similar: [Result]
}

enum DetailSection {
    case header
    case similar
}

enum DetailItem {
    case header(MediaDetail)
    case media(Result)
}

struct DetailSectionModel {
    var header: String
    var items: [DetailItem]
}

extension DetailSectionModel: SectionModelType {
    typealias Item = DetailItem
    
    init(original: DetailSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}


final class DetailViewController: BaseViewController {

    private let detailView = DetailView()
    private let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    var media: Result?
    
    private var dataSource: RxCollectionViewSectionedReloadDataSource<DetailSectionModel>!
    
    // 미디어 설명 레이블 (더보기 처리)
    private var isTapped = false
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        bind()
    }
    
    override func setViewController() {
        super.setViewController()
        detailView.similarCollectionView.collectionViewLayout = DetailViewController.createCompositionalLayout
    }
    
    static  func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.dataSource.sectionModels[sectionIndex].section
            switch section {
            case .header:
                return self.createHeaderSection()
            case .similar:
                return self.createSimilarSection()
            }
        }
    }
    
    private func createHeaderSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createSimilarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    private func setDataSource() {
        dataSource = RxCollectionViewSectionedReloadDataSource<DetailSectionModel>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                
                
                switch item {
                case .header(let headerData):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.identifier, for: indexPath) as? DetailHeaderCell else {
                        return UICollectionViewCell()
                    }
                    // let header = dataSource[indexPath.section].items[0]
                    cell.updateCell(with: headerData)
                    self?.detailView.updateDetailMainImage(headerData.movie.posterPath)
                    return cell
                    
                case .media(let mediaData):
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.configure(with: mediaData[indexPath.item])
                    return cell
                }
                
                // if indexPath.section != 0 {
                //     guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailHeaderCell.identifier, for: indexPath) as? DetailHeaderCell else { return DetailHeaderCell() }
                //     cell.backgroundColor = .cyan
                //     let header = dataSource[indexPath.section].header
                //     print("🚨", header)
                //     cell.updateCell(with: header)
                //
                //     return cell
                // } else {
                //     guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
                //         return MediaCollectionViewCell()
                //     }
                //
                //     // let data = dataSource[indexPath.section].items
                //     cell.configure(with: item)
                //
                //     return cell
                // }
            }
        )
    }
    
    private func bind() {
        let mediaSubject = PublishSubject<Result>()
        
        let input = DetailViewModel.Input(mediaSubject: mediaSubject)
        let output = viewModel.transform(input: input)
        
        guard let media = media else { return }
        mediaSubject.onNext(media)
        // headerView.overviewLabel.rx.tapGesture()
        //     .when(.recognized)  /// tapGesture()를 그냥 사용 시, sampleView 바인딩 할 때 event가 emit되므로 해당 코드 추가
        //     .subscribe { [weak self] _ in
        //         print("설명 영역 탭했어요!")
        //         self?.toggleOverviewLabel()
        //     }
        //     .disposed(by: disposeBag)
        
        output.dataSource
            .bind(to: detailView.similarCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // private func toggleOverviewLabel() {
    //     isTapped.toggle()
    //     headerView.overviewLabel.numberOfLines = isTapped ? 0 : 2
    //
    //     UIView.animate(withDuration: 0.3) {
    //         self.headerView.layoutIfNeeded()
    //     }
    // }
    
}
