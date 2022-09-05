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
    
    let mainView = WriteView()
    
    var objectID = ObjectId()
        
    override func loadView() {
        self.view = mainView
        print("It's WriteViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav()
        setKeyboard()
        print("It's writeViewController viewDidLoard")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UserDefaults.standard.set(false, forKey: UserDefault.showingKeyboard.rawValue)
        
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)

        let textArray = mainView.textView.text!.split(separator: "\n", maxSplits: 1)
        
        if UserDefaults.standard.bool(forKey: UserDefault.pushedFromCell.rawValue) {
            let memo = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
                $0._id == objectID
            }.first!
            if textArray.count == 0 {
                try! realm.write {
                realm.delete(memo)
                }
            } else {
                try! realm.write {
                    switch textArray.count {
                    case 0:
                        break
                    case 1:
                        memo.title = String(textArray[0])
                    case 2:
                        memo.title = String(textArray[0])
                        memo.content = String(textArray[1])
                    default:
                        break
                    }
                }

            }
        } else {
            if textArray.count != 0 {
                self.saveMemo()
            }
        
        UserDefaults.standard.set(false, forKey: UserDefault.pushedFromCell.rawValue)
        }
    }
    
    func setKeyboard() {
        if UserDefaults.standard.bool(forKey: UserDefault.showingKeyboard.rawValue) {
            mainView.textView.becomeFirstResponder()
        }
    }
    
    private func setNav() {
        let completeBtn = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(completeBtnClicked))
        let shareBtn = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .done, target: self, action: #selector(shareBtnClicked))
        self.navigationItem.rightBarButtonItems = [completeBtn, shareBtn]
        
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    @objc private func completeBtnClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func saveMemo() {
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
        
        guard title.isEmpty else {
            try! realm.write {
                realm.add(Memo(title: title, content: content, date: Date()))
            }
            return }
    }
        
    @objc private func shareBtnClicked() {
        print(#function)
        let activityViewController = UIActivityViewController(activityItems: [mainView.textView.text!], applicationActivities: nil)

        activityViewController.excludedActivityTypes = []

        // 3. 컨트롤러를 닫은 후 실행할 완료 핸들러 지정
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if success {
                self.presentCheckAlert(title: "내보내기", message: "성공")
           }  else  {
               self.presentCheckAlert(title: "내보내기", message: "실패")
           }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}
