//
//  SearchViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class SearchViewController: BaseViewController {
    
    private let searchView = SearchView()
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    private func bind() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MediaSection>(
               configureCell: { dataSource, collectionView, indexPath, item in
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPlayCollectionViewCell.identifier, for: indexPath) as! MediaPlayCollectionViewCell
//                   cell.configure()
                   return cell
               },
               configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                   let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaSectionHeaderView.identifier, for: indexPath) as! MediaSectionHeaderView
                   let section = dataSource[indexPath.section]
                   header.configure(with: section.model)
                   return header
               }
           )
           
           searchView.searchCollectionView.register(MediaSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MediaSectionHeaderView.identifier)
           
           let input = SearchViewModel.Input(
               searchText: searchView.searchBar.rx.text.orEmpty,
               itemSelected: searchView.searchCollectionView.rx.itemSelected
               
           )
           
           let output = viewModel.transform(input: input)
           
           output.searchResults
               .map { [
                   MediaSection(model: "추천 시리즈 & 영화", items: $0)
               ] }
               .drive(searchView.searchCollectionView.rx.items(dataSource: dataSource))
               .disposed(by: disposeBag)
    }
    override func setViewController() {
        navigationController?.isNavigationBarHidden = true
    }
    deinit {
        print("Deinit SearchViewController")
    }
    
}
