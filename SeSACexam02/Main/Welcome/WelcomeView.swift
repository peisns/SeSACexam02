//
//  WelcomeView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit

final class WelcomeView: BaseView {
    
    var welcomeVC = UIViewController()

    private let centerView = UIView().then {
        $0.backgroundColor = UIColor(red: CGFloat(82/255), green: CGFloat(86/255), blue: CGFloat(88/255), alpha: 1)
        $0.layer.cornerRadius = 15
    }
    
    private let label = UILabel().then {
        let labelText = """
                        처음 오셨군요!
                        환영합니다 :)

                        당신만의 메모를 작성하고
                        관리해보세요!
                        """
        $0.text = labelText
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let button = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = .systemOrange
        $0.layer.cornerRadius = 15
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        self.backgroundColor = UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(0/255), alpha: 0.90)

        self.addSubview(centerView)
        [label, button].forEach {centerView.addSubview($0)}
        
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    }
    
    @objc private func buttonClicked() {
        welcomeVC.dismiss(animated: false)
        UserDefaults.standard.set(true, forKey: userDefaults.checkWelcomeView.rawValue)
    }
    
    override func setConstraints() {
        
        centerView.snp.makeConstraints { make in
            make.center.equalTo(self)
            make.width.height.equalTo(250)
        }
        
        label.snp.makeConstraints { make in
            make.trailing.top.leading.equalTo(centerView).inset(20)
            make.bottom.equalTo(button.snp.top).offset(-20)
        }
        
        button.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(centerView).inset(20)
            make.height.equalTo(44)
        }

    }
}
