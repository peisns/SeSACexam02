//
//  WelcomeViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit

class WelcomeViewController: BaseViewController {

    let mainView = WelcomeView()
    
    override func loadView() {
        self.view = mainView
        mainView.welcomeVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
