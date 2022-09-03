//
//  MainTableViewCell.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    let titleLabel = UILabel().then {
        $0.text = "title"
        $0.textColor = .label
    }

    
    let dateContentView = UIView().then {
        _ in
    }
    
    let dateLabel = UILabel().then {
        $0.text = "date"
        $0.textColor = .label
        
    }
    
    let contentLabel = UILabel().then {
        $0.text = "content"
        $0.textColor = .label
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MainTableViewCell.reuseIdentifier)
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setConfigure() {
        self.contentView.addSubview(stackView)
        [titleLabel, dateContentView].forEach {stackView.addArrangedSubview($0)}
        [dateLabel, contentLabel].forEach {dateContentView.addSubview($0)}
    }
    
    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentView).inset(16)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(dateContentView)
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing)
            make.top.trailing.bottom.equalTo(dateContentView)
        }
    }

}
