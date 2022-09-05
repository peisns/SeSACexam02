//
//  WelcomeViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit

final class WelcomeViewController: BaseViewController {

    let mainView = WelcomeView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc func buttonClicked() {
        dismiss(animated: false)
        UserDefaults.standard.set(true, forKey: UserDefault.checkWelcomeView.rawValue)
    }

}
