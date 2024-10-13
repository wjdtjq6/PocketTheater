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

struct TestData {
    let title: String
    let image: UIImage
}

struct LikeDataSection {
    var header: String
    var items: [TestData]   /// `[Like]`
}

extension LikeDataSection: SectionModelType {
    typealias Item = TestData /// `Like`
    
    init(original: LikeDataSection, items: [Item]) {
        self = original
        self.items = items
    }
}

final class LikeViewController: BaseViewController {
    
    private let likeView = LikeView()
    private let viewModel = LikeViewModel()
    private let disposeBag = DisposeBag()
    
    private var dataSource: RxTableViewSectionedReloadDataSource<LikeDataSection>!

    private let viewDidLoadTrigger = PublishSubject<Void>()
    
    override func loadView() {
        view = likeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constant.Like.navigationTitle
        likeView.likeTableView.delegate = self
        // Datasource 생성 & SectionTitle 구성
        dataSource = LikeViewController.dataSource()
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].header
        }
        bind()
        viewDidLoadTrigger.onNext(())
    }
    
    deinit {
        print("Deinit LikeViewController")
    }
    
    private func bind() {
        let input = LikeViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            itemDeleted: likeView.likeTableView.rx.modelDeleted(TestData.self)
        )
        let output = viewModel.transform(input: input)
        
        // 내가 찜한 리스트 데이터 바인딩
        output.likeList
            .bind(to: likeView.likeTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
       
        
    }
    
}

extension LikeViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<LikeDataSection> {
        return RxTableViewSectionedReloadDataSource<LikeDataSection>(
            configureCell: { dataSource, collectionView, indexPath, data in
                guard let cell = collectionView.dequeueReusableCell(withIdentifier: MediaPlayTableViewCell.identifier, for: indexPath) as? MediaPlayTableViewCell else { return MediaPlayTableViewCell() }
                
                cell.updateCell(item: data)
                return cell
            }
        )
    }
}

// MARK: 찜한 리스트 테이블뷰 Header 색상 변경
extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Resource.Color.white
        
        if #available(iOS 14.0, *) {
            header.backgroundConfiguration?.backgroundColor = Resource.Color.black
    
        } else {
            header.contentView.backgroundColor = Resource.Color.black
        }
    }
}
