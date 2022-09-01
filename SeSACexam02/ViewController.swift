//
//  ViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentMainVC()
    }
    
    func presentMainVC() {
        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: false)
    }
}

