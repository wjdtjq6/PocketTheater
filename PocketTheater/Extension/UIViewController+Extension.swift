//
//  UIViewController+Extension.swift
//  PocketTheater
//
//  Created by 김윤우 on 10/8/24.
//

import UIKit

extension UIViewController {
    
    enum TransitionMode {
        case present
        case push
    }
    
    //MARK: completionHandler + 화면전환
    func goToOtehrVCwithCompletionHandler<T: UIViewController>(vc: T, mode: TransitionMode,tabbarHidden: Bool? = nil, completionHandler: @escaping (T) -> Void ) {
        let vc = vc
        switch mode {
        case .present:
            present(vc, animated: true) { [weak self] in
                guard self != nil else { return }
                completionHandler(vc)
            }
        case .push:
            vc.hidesBottomBarWhenPushed = tabbarHidden ?? false
            navigationController?.pushViewController(vc, animated: true)
            
        }
        completionHandler(vc)
    }
    
    //MARK: 화면전환
    func goToOtehrVC(vc: UIViewController, mode: TransitionMode, tabbarHidden: Bool? = nil) {
        let vc = vc
        switch mode {
        case .present:
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .flipHorizontal
            present(vc, animated: true)
        case .push:
            vc.hidesBottomBarWhenPushed = tabbarHidden ?? false
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: 뒤로가기
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
}
