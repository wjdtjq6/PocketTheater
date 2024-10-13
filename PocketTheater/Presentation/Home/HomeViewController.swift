//
//  HomeViewController.swift
//  PocketTheater
//
//  Created by junehee on 10/9/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: BaseViewController {
    
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()
    private var viewModel: HomeViewModel?
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewModel 초기화
        Task {
            do {
                viewModel = try await HomeViewModel()
                DispatchQueue.main.async {
                    self.setupBindings()
                }
            } catch {
                print("뷰모델 초기화 중 오류 발생: \(error)")
            }
        }
        
        homeView.collectionView.register(FeaturedMediaCell.self, forCellWithReuseIdentifier: "FeaturedMediaCell")
        homeView.collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: "MediaCollectionViewCell")
        homeView.collectionView.register(MediaSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MediaSectionHeaderView")
        homeView.collectionView.collectionViewLayout = createLayout()
     }
    
     private func createLayout() -> UICollectionViewLayout {
         return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
             guard let self = self else { return nil }
                
             switch sectionIndex {
                case 0: return createFeaturedSection()
                case 1,2: return createHorizontalSection()
                default: return createHorizontalSection()
                }
            }
        }
    
       private func createFeaturedSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .groupPagingCentered
           
           return section
       }

        private func createHorizontalSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(0.5))
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .continuous
           
           let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
           let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
           section.boundarySupplementaryItems = [header]
           
           return section
       }
    
        private func setupBindings() {
         
         guard let viewModel = viewModel else {
             print("ViewModel is not initialized")
             return
         }
         
         let dataSource = RxCollectionViewSectionedReloadDataSource<MediaSection>(
             configureCell: { dataSource, collectionView, indexPath, item in
                 switch indexPath.section {
                 case 0: // Featured section
                     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedMediaCell", for: indexPath) as! FeaturedMediaCell
                     viewModel.loadImage(for: item)
                         .observe(on: MainScheduler.instance)
                         .map { UIImage(data: $0 as! Data) }
                         .bind(to: cell.imageView.rx.image)
                         .disposed(by: cell.disposeBag)
                     return cell
                 case 1, 2: // Movies and TV Series sections
                     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCollectionViewCell", for: indexPath) as! MediaCollectionViewCell
                     viewModel.loadImage(for: item)
                         .observe(on: MainScheduler.instance)
                         .map { UIImage(data: $0 as! Data) }
                         .bind(to: cell.mediaImageView.rx.image)
                         .disposed(by: cell.disposeBag)
                     return cell
                 default:
                     return UICollectionViewCell()
                 }
             },
             configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                 let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MediaSectionHeaderView", for: indexPath) as! MediaSectionHeaderView
                 header.titleLabel.text = dataSource[indexPath.section].header
                 return header
             }
         )
         
         viewModel.sections
             .bind(to: homeView.collectionView.rx.items(dataSource: dataSource))
             .disposed(by: disposeBag)
         
     }
     
     deinit {
         print("Deinit HomeViewController")
     }
 }

