//
//  SearchView.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import SnapKit
import Then

class SearchView: BaseView {
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "게임, 시리즈, 영화를 검색하세요."
        $0.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        $0.barStyle = .black
        $0.searchBarStyle = .minimal
    }
    
    private lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: Resource.CollectionViewLayout.MediaLayout()).then {
           $0.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
           $0.dataSource = self
       }
    private let dummyData = ["image1", "image2", "image3", "image4", "image5", "image6","image1", "image2", "image3", "image4", "image5", "image6","image1", "image2", "image3", "image4", "image5", "image6"]
    
    override func setHierarchy() {
        self.addSubview(searchBar)
        self.addSubview(searchCollectionView)
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
   
    static func createTableViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
 
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.33))
 
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    
    }
    
}

extension SearchView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dummyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
                    return UICollectionViewCell()
                }
        
        return cell
    }
    
    
}
