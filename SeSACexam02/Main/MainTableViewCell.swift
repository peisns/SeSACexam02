//
//  MainTableViewCell.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MainTableViewCell.reuseIdentifier)
        
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
