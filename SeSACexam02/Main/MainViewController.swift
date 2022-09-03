//
//  MainViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit
import RealmSwift

final class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let realm = try! Realm()
    
    override func loadView() {
        self.view = mainView
        mainView.vc = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        setToolBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        showTitle()
        presentWelcomeVC()
        mainView.mainTableView.reloadData()
    }

    private func setNav() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .systemBackground
        navBarAppearance.shadowColor = .clear // underline color
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모"
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .systemOrange
        searchController.searchBar.searchTextField.placeholder = "검색"
        self.navigationItem.searchController = searchController
        

        
    }
    
    func showTitle() {
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
        navigationItem.title = memos.count == 0 ? "메모" : "\(memos.count)개의 메모"
    }
//
    private func setToolBar() {
        navigationController?.isToolbarHidden = false
        let toolBarWriteBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .done, target: self, action: #selector(writeBtnClicked))
        toolBarWriteBtn.tintColor = .systemOrange
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, toolBarWriteBtn]
    }
//
    @objc private func writeBtnClicked() {
        let vc = WriteViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
//
    func presentWelcomeVC() {
        guard UserDefaults.standard.bool(forKey: userDefaults.checkWelcomeView.rawValue) else {
                let vc = WelcomeViewController()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false)
            return }
    }
}
