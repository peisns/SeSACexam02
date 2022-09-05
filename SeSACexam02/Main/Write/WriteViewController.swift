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
    lazy var textArray = mainView.textView.text!.split(separator: "\n", maxSplits: 1)
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        setKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set(false, forKey: UserDefault.showingKeyboard.rawValue)
        
        if UserDefaults.standard.bool(forKey: UserDefault.pushedFromCell.rawValue) {
            let memo = RealmManager.shared.memos.where {
                $0._id == objectID
            }.first!
            if textArray.count == 0 {
                RealmManager.shared.delete(memo: memo)
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
        }
        UserDefaults.standard.set(false, forKey: UserDefault.pushedFromCell.rawValue)
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
        var title = ""
        var content = ""
        makeTitleAndContent(Array: textArray, title: &title, content: &content)
        guard title.isEmpty else {
            try! realm.write {
                realm.add(Memo(title: title, content: content, date: Date()))
            }
            return }
    }
    
    func makeTitleAndContent(Array: [String.SubSequence], title: inout String, content: inout String) {
        switch Array.count {
        case 0:
            break
        case 1:
            title = String(Array[0])
        case 2:
            title = String(Array[0])
            content = String(Array[1])
        default:
            break
        }
    }
    
    @objc private func shareBtnClicked() {
        print(#function)
        let activityViewController = UIActivityViewController(activityItems: [mainView.textView.text!], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = []
        
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
