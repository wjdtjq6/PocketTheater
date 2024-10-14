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

final class HomeViewController: BaseViewController, UIScrollViewDelegate {
    
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()
    private var viewModel: HomeViewModel!
    private let loadTrigger = PublishSubject<Void>()
    private let likeRepository = LikeRepository()
    
    private var overlayView: UIView?
    private var alertView: CustomAlertView?
    private var isAlertShowing = false

    private let netflixLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "Netflix_Symbol_RGB")
        $0.contentMode = .scaleAspectFit
    }
    
    private let chromecastButton = UIButton().then {
        $0.setImage(UIImage(systemName: "sparkles.tv"), for: .normal)
        $0.tintColor = .white
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        setupNavigationBar()
        setupBindings()
        likeRepository.getFileURL()
        // 셀 등록
        homeView.collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)
        homeView.collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        // Trigger initial load
        loadTrigger.onNext(())
    }
    
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<HomeMediaSection> {
        return RxCollectionViewSectionedReloadDataSource<HomeMediaSection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                if indexPath.section == 0 {
                    // 특집 섹션용 셀
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as! FeaturedCollectionViewCell
                    
                    self?.viewModel.loadImage(for: item)
                        .observe(on: MainScheduler.instance)
                        .map { UIImage(data: $0 ?? Data()) }
                        .bind(to: cell.mediaImageView.rx.image)
                        .disposed(by: cell.disposeBag)
                    
                    // 장르 정보 가져오기
                    self?.viewModel.fetchGenre(for: item)
                        .observe(on: MainScheduler.instance)
                        .subscribe(onNext: { genre in
                            cell.configure(with: genre)
                        }, onError: { error in
                            print("Error fetching genre: \(error)")
                            cell.genreLabel.isHidden = true
                        })
                        .disposed(by: cell.disposeBag)
                    
                    // 버튼 동작 설정
                    cell.playButton.rx.tap
                        .subscribe(onNext: { [weak self] in
                            self?.playMedia(item)
                        })
                        .disposed(by: cell.disposeBag)
                    
                    cell.myListButton.rx.tap
                        .subscribe(onNext: { [weak self] in
                            self?.addToMyList(item)
                        })
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                } else {
                    // 수평 섹션용 셀
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell
                    
                    self?.viewModel.loadImage(for: item)
                        .observe(on: MainScheduler.instance)
                        .map { UIImage(data: $0 ?? Data()) }
                        .bind(to: cell.mediaImageView.rx.image)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeMediaSectionHeaderView.identifier, for: indexPath) as! HomeMediaSectionHeaderView
                header.titleLabel.text = dataSource[indexPath.section].header
                return header
            }
        )
    }
    
    private func setupNavigationBar() {
        let logoContainer = UIView()
        logoContainer.addSubview(netflixLogoImageView)
        netflixLogoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(-30)
            make.centerY.equalToSuperview()
            make.width.equalTo(50) // 로고 너비 조정
            make.height.equalTo(50)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)
        
        let chromecastBarButton = UIBarButtonItem(customView: chromecastButton)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItems = [searchBarButton, chromecastBarButton]
    }
    
    private func setupBindings() {
        let input = HomeViewModel.Input(loadTrigger: loadTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(homeView.collectionView.rx.items(dataSource: createDataSource()))
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(homeView.activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
        
        // 컬렉션 뷰 아이템 선택 처리
        homeView.collectionView.rx.modelSelected(Result.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self, !self.isAlertShowing else { return }
                if !self.isFeaturedSection(for: item) {
                    self.navigateToDetailViewController(with: item)
                }
            })
            .disposed(by: disposeBag)
        
        // 'My List' 버튼 탭 처리 (FeaturedCollectionViewCell에 있는 경우)
        // 이 부분은 FeaturedCollectionViewCell에 myListButton이 있다고 가정합니다.
        homeView.collectionView.rx.modelSelected(Result.self)
            .filter { [weak self] item in self?.isFeaturedSection(for: item) == true }
            .subscribe(onNext: { [weak self] item in
                self?.addToMyList(item)
            })
            .disposed(by: disposeBag)
    }
    
    private func isFeaturedSection(for item: Result) -> Bool {
        // Featured 섹션인지 확인하는 로직
        // 예: item의 특정 속성을 확인하거나, 섹션 인덱스를 확인
        return false // 임시로 false 반환
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
               
            switch sectionIndex {
               case 0: return self.createFeaturedSection()
               case 1: return self.createCurrentMoviesSection()
               default: return self.createHorizontalSection()
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
      
    private func createCurrentMoviesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
          
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.75))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
          
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
          
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
          
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func playMedia(_ item: Result) {
        // 여기에 미디어 재생 로직을 구현하세요
        print("Playing media: \(item)")
    }

    private func addToMyList(_ item: Result) {
        Task {
            do {
                if let _ = likeRepository.getLikeMedia(id: item.id) {
                    await MainActor.run {
                        showAlert(message: "이미 저장된 미디어에요 :)")
                    }
                    return
                }
                
                guard let posterPath = item.posterPath else {
                    throw NSError(domain: "PosterPathError", code: 0, userInfo: [NSLocalizedDescriptionKey: "포스터 경로가 없습니다."])
                }
                
                let imageData = try await NetworkManager.shared.fetchImage(imagePath: posterPath)
                
                let fileName = "\(item.id).jpg"
                let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
                try imageData.write(to: fileURL)
                
                let newLike = Like(media: item, imagePath: fileURL.path)
                try likeRepository.addLikeMedia(newLike)
                
                await MainActor.run {
                    showAlert(message: "미디어를 저장했어요 :)")
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "미디어 저장에 실패했어요 :(")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        guard !isAlertShowing else { return }
        
        overlayView = UIView(frame: view.bounds)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(overlayView!)
        
        alertView = CustomAlertView(message: message)
        alertView?.onConfirm = { [weak self] in
            self?.hideAlert()
        }
        view.addSubview(alertView!)
        
        alertView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(350)
            make.height.equalTo(120)
        }
        
        isAlertShowing = true
    }
    
    private func hideAlert() {
        overlayView?.removeFromSuperview()
        alertView?.removeFromSuperview()
        overlayView = nil
        alertView = nil
        isAlertShowing = false
    }
    
    private func navigateToDetailViewController(with item: Result) {
        let vc = DetailViewController()
        goToOtehrVC(vc: vc, mode: .present)
    }
    
    deinit {
        print("Deinit HomeViewController")
    }
    
}
