//
//  MainViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit
import RealmSwift


class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let realm = try! Realm()
    
    var filteredArr: [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
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
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "메모"
        
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
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.tintColor = .systemOrange
        searchController.searchBar.searchTextField.placeholder = "검색"
        self.navigationItem.searchController = searchController
        
    }
    
    func showTitle() {
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let memosCount = numberFormatter.string(from: memos.count as NSNumber) ?? "0"

        navigationItem.title = Int(memosCount) == 0 ? "메모" : "\(memosCount)개의 메모"
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
        UserDefaults.standard.set(true, forKey: UserDefault.showingKeyboard.rawValue)
        let vc = WriteViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
//
    func presentWelcomeVC() {
        guard UserDefaults.standard.bool(forKey: UserDefault.checkWelcomeView.rawValue) else {
                let vc = WelcomeViewController()
                vc.modalPresentationStyle = .overFullScreen
                present(vc, animated: false)
            return }
    }
    
    func searchBarIsEmpty() -> Bool {
      // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        let memos = realm.objects(Memo.self).where {
            $0.title.contains(text, options: .caseInsensitive) ||
            $0.content.contains(text, options: .caseInsensitive)
        }.sorted(byKeyPath: "date", ascending: false)
        mainView.filteredMemo = memos
        mainView.searchBarIsEmpty = searchBarIsEmpty()
        mainView.searchKeyword = text
        mainView.mainTableView.reloadData()
        print(memos)
    }
}
