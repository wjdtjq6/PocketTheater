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
        setupDataSource()
        bind()
        viewDidLoadTrigger.onNext(())
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedReloadDataSource<LikeDataSection>(
            configureCell: { dataSource, tableView, indexPath, like in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MediaPlayTableViewCell.identifier, for: indexPath) as? MediaPlayTableViewCell else { return MediaPlayTableViewCell() }
                cell.updateCell(item: like)
                return cell
            }
        )
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    }
    
    private func bind() {
        let input = LikeViewModel.Input(
            viewDidLoadTrigger: viewDidLoadTrigger,
            itemDeleted: likeView.likeTableView.rx.itemDeleted
                .withLatestFrom(likeView.likeTableView.rx.modelDeleted(Like.self))
        )
        let output = viewModel.transform(input: input)
        
        output.likeList
            .bind(to: likeView.likeTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        likeView.likeTableView.rx.modelSelected(Like.self)
            .subscribe(onNext: { [weak self] like in
                self?.handleSelectedItem(like)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleSelectedItem(_ like: Like) {
        print("Selected item: \(like.title)")
        // 여기에 선택된 항목에 대한 추가 처리를 구현하세요.
    }
}

extension LikeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = Resource.Color.white
        header.textLabel?.font = Resource.Font.bold18
        
        if #available(iOS 14.0, *) {
            header.backgroundConfiguration?.backgroundColor = Resource.Color.black
        } else {
            header.contentView.backgroundColor = Resource.Color.black
        }
    }
}
