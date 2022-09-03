//
//  WriteViewController.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import UIKit
import RealmSwift

final class WriteViewController: BaseViewController {
    let realm = try! Realm()
    
    private let mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
    }
    
    private func setNav() {
        let completeBtn = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(completeBtnClicked))
        let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBtnClicked))
        self.navigationItem.rightBarButtonItems = [completeBtn, shareBtn]
        
        navigationItem.largeTitleDisplayMode = .never

    }
    
    @objc private func completeBtnClicked() {
        let textArray = mainView.textView.text!.split(separator: "\n", maxSplits: 1)
        var title = ""
        var content = ""
        switch textArray.count {
        case 0:
            break
        case 1:
            title = String(textArray[0])
        case 2:
            title = String(textArray[0])
            content = String(textArray[1])
        default:
            break
        }

        navigationController?.popViewController(animated: true)

        guard title.isEmpty else {
            try! realm.write {
                realm.add(Memo(title: title, content: content, date: Date()))
            }
//            읽어오는 방법
//            let memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
//            print(memos)
        return }
    }

    
    @objc private func shareBtnClicked() {
        print(#function)
    }


    

    
}
