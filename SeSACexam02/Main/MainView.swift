//
//  MainView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit

final class MainView: BaseView {
    var mainVC = UIViewController()
    
    var mainTableView = UITableView().then {
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        self.addSubview(mainTableView)
        
    }
    
    override func setConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    

}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
