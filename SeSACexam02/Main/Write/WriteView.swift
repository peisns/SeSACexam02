//
//  WriteView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit

final class WriteView: BaseView {
    
    let textView = UITextView().then {
        $0.backgroundColor = .systemBackground
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(textView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    } 
}
