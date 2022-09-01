//
//  BaseView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit

import SnapKit
import Then


class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setConfigure() {
        backgroundColor = .systemBackground
    }
    
    func setConstraints() {
        
    }
    
}
