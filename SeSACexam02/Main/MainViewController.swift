//
//  MainViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit

final class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
        mainView.mainVC = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        presentWelcomeVC()
    }
    
    func setNav() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear // underline color
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label.cgColor] // title color
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "메모"
        self.navigationController?.navigationBar.tintColor = .black

    }
    
    func presentWelcomeVC() {
        guard UserDefaults.standard.bool(forKey: userDefaults.checkWelcomeView.rawValue) else {
                let vc = WelcomeViewController()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false)
            return }
    }
}
