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
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<MediaSection1>(
            configureCell: { dataSource, collectionView, indexPath, item in
                if dataSource[indexPath.section].model == "추천 시리즈 & 영화" {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaPlayCollectionViewCell.identifier, for: indexPath) as! MediaPlayCollectionViewCell
                    cell.configure(with: item)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as! MediaCollectionViewCell
                    cell.configure(with: item)
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MediaSectionHeaderView.identifier, for: indexPath) as! MediaSectionHeaderView
                let section = dataSource[indexPath.section]
                header.configure(with: section.model)
                return header
            }
        )
        
        
        
        let input = SearchViewModel.Input(
            searchText: searchView.searchBar.rx.text.orEmpty,
            itemSelected: searchView.searchCollectionView.rx.itemSelected,
            prefetchItems: searchView.searchCollectionView.rx.prefetchItems
            
        )
        
        let output = viewModel.transform(input: input)
        
        searchView.searchCollectionView.rx.prefetchItems
            .bind(with: self) { owner, value in
                
            }
            .disposed(by: disposeBag)
        output.mediaResults
            .drive(searchView.searchCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isSearching
            .drive(onNext: { [weak self] isSearching in
                self?.searchView.searchCollectionView.collectionViewLayout = isSearching ?
                Resource.CollectionViewLayout.MediaLayout() :
                Resource.CollectionViewLayout.createMediaPlayCellLayout()
            })
            .disposed(by: disposeBag)
        
        output.hasNoResults
            .drive(onNext: { [weak self] hasNoResults in
                self?.searchView.noResultsLabel.isHidden = !hasNoResults
                self?.searchView.searchCollectionView.isHidden = hasNoResults
            })
            .disposed(by: disposeBag)
        output.gotoDetail
            .subscribe(with: self) { owner , mediaID in
                //MARK: DetailView mediaID 값 넘겨서 연결
               owner.goToOtehrVCwithCompletionHandler(vc: DetailViewController(), mode: .present) { mediaID in
                   
               }
            }
            .disposed(by: disposeBag)
    }
    override func setViewController() {
        navigationController?.isNavigationBarHidden = true
        hideKeyboardWhenTappedAround()
    }
    deinit {
        print("Deinit SearchViewController")
    }
    
}
