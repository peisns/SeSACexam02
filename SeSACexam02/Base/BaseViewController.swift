//
//  BaseViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func presentCheckAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let check = UIAlertAction(title: "확인", style: .default)
        controller.addAction(check)
        present(controller, animated: true)
    }
    
    func presentAlert(title: String, message: String, handler: @escaping () -> ()) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let check = UIAlertAction(title: "확인", style: .destructive) { action in
            handler()
        }
        
        controller.addAction(cancel)
        controller.addAction(check)
        
        present(controller, animated: true)
    }
    

}
