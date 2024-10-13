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
    private var viewModel: HomeViewModel!
    private let loadTrigger = PublishSubject<Void>()
    
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
        
        // 셀 등록
        homeView.collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: "FeaturedCollectionViewCell")
        homeView.collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        // Trigger initial load
        loadTrigger.onNext(())
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
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<MediaSection>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                if indexPath.section == 0 {
                    // 특집 섹션용 셀
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionViewCell", for: indexPath) as! FeaturedCollectionViewCell
                    
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
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
                    
                    self?.viewModel.loadImage(for: item)
                        .observe(on: MainScheduler.instance)
                        .map { UIImage(data: $0 ?? Data()) }
                        .bind(to: cell.mediaImageView.rx.image)
                        .disposed(by: cell.disposeBag)
                    
                    return cell
                }
            },
            configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MediaSectionHeaderView", for: indexPath) as! MediaSectionHeaderView
                header.titleLabel.text = dataSource[indexPath.section].header
                return header
            }
        )
        
        output.sections
            .drive(homeView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.homeView.activityIndicator.startAnimating()
                } else {
                    self?.homeView.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] errorMessage in
                if !errorMessage.isEmpty {
                    self?.showErrorAlert(message: errorMessage)
                }
            })
            .disposed(by: disposeBag)
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
        // 여기에 '내가 찜한 리스트'에 추가하는 로직을 구현하세요
        print("Added to my list: \(item)")
    }
    
    deinit {
        print("Deinit HomeViewController")
    }
}
