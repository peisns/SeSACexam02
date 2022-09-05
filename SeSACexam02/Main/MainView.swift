//
//  MainView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit
import RealmSwift

class MainView: BaseView {
    
    var vc = BaseViewController()
    
    var searchBarIsEmpty = true
    
    let realm = try! Realm()
    
    var filteredMemo: Results<Memo>?
    
    var searchKeyword = ""
    
    var mainTableView = UITableView(frame: CGRect() , style: .insetGrouped).then {
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
        mainTableView.keyboardDismissMode = .onDrag
        
        self.addSubview(mainTableView)
        }
    
    override func setConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchBarIsEmpty {
            return mainTableViewHeaderTitle.allCases[section].rawValue
        } else {
            guard let filteredMemo = filteredMemo else { return "" }
            if section == 0 {
                let markedMemos = filteredMemo.where {
                    $0.isMarked == true
                }
                return "\(markedMemos.count)개 찾음"
                
            } else {
                let notMarkedMemos = filteredMemo.where {
                    $0.isMarked == false
                }
                return "\(notMarkedMemos.count)개 찾음"
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarIsEmpty {
            if section == 0 {
                let markedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
                    $0.isMarked == true
                }
                return markedMemos.count
                
            } else {
                let notMarkedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
                    $0.isMarked == false
                }
                return notMarkedMemos.count
            }
        } else {
            guard let filteredMemo = filteredMemo else { return 0 }
            if section == 0 {
                let markedMemos = filteredMemo.where {
                    $0.isMarked == true
                }
                return markedMemos.count
                
            } else {
                let notMarkedMemos = filteredMemo.where {
                    $0.isMarked == false
                }
                return notMarkedMemos.count
            }
        }
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }

        let memos : Results<Memo>
        if searchBarIsEmpty {
            memos = indexPath.section == 0 ? realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where { $0.isMarked == true } : realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where { $0.isMarked == false }
            cell.titleLabel.text = memos[indexPath.row].title
            cell.contentLabel.text = memos[indexPath.row].content!.isEmpty ? "추가 텍스트 없음" : memos[indexPath.row].content
            
        } else {
            guard let filteredMemo = filteredMemo else { return UITableViewCell() }
            memos = indexPath.section == 0 ? filteredMemo.where { $0.isMarked == true } : filteredMemo.where { $0.isMarked == false }
            let titleAttributedWithTextColor: NSAttributedString = memos[indexPath.row].title.attributedStringWithColor([searchKeyword], color: UIColor.systemOrange)
            cell.titleLabel.attributedText = titleAttributedWithTextColor
            
            if memos[indexPath.row].content!.isEmpty {
                cell.contentLabel.text = "추가 텍스트 없음"
            } else {
                let contentAttributedWithTextColor: NSAttributedString = memos[indexPath.row].content!.attributedStringWithColor([searchKeyword], color: UIColor.systemOrange)
                cell.contentLabel.attributedText = contentAttributedWithTextColor
            }
        }
                
        let date = memos[indexPath.row].date

        let newDate = formattingDate(date: date)
        cell.dateLabel.text = newDate

        return cell
    }
    
    func formattingDate(date: Date) -> String {
        let DF = DateFormatter()
        DF.locale = Locale(identifier:"ko_KR")
        switch dateGap(date: date) {
        case 0:
            DF.dateFormat = "a hh:mm"
        case 1...6:
            DF.dateFormat = "EEEE"
        default:
            DF.dateFormat = "yyyy. MM. dd. a hh:mm "
        }
        let newDate = DF.string(from: date)
        return newDate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (16 * 2) + 60
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let markedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
            $0.isMarked == true
        }
        let notMarkedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
            $0.isMarked == false
        }

        if indexPath.section == 0 {
            let mark = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                try! self.realm.write {
                    markedMemos[indexPath.row].isMarked = false
                }
                tableView.reloadData()
            }
            mark.image = UIImage(systemName: "pin.slash.fill")
            return UISwipeActionsConfiguration(actions: [mark])
        } else {
            let notMark = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                if markedMemos.count > 4 {
                    self.vc.presentCheckAlert(title: "너무 많은 메모 고정", message: "메모는 최대 5개까지 고정할 수 있습니다." )
                    
                } else {
                    try! self.realm.write {
                        notMarkedMemos[indexPath.row].isMarked = true
                    }
                }
                tableView.reloadData()
            }
            notMark.image = UIImage(systemName: "pin.fill")
            return UISwipeActionsConfiguration(actions: [notMark])
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let markedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
            $0.isMarked == true
        }
        let notMarkedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
            $0.isMarked == false
        }
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
        var delete = UIContextualAction()

        if indexPath.section == 0 {
            delete = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                
                self.vc.presentAlert(title: "삭제", message: "정말로 삭제하시겠습니까?") {
                    try! self.realm.write {
                        
                        let memo = markedMemos[indexPath.row]
                        self.realm.delete(memo)
                        
                        tableView.reloadData()
                        self.vc.navigationItem.title = memos.count == 0 ? "메모" : "\(memos.count)개의 메모"
                    }
                }
                tableView.reloadData()
            }
        } else {
            delete = UIContextualAction(style: .destructive, title: nil) { action, view, completionHandler in
                
                self.vc.presentAlert(title: "삭제", message: "정말로 삭제하시겠습니까?") {
                    try! self.realm.write {
                        
                        let memo = notMarkedMemos[indexPath.row]
                        self.realm.delete(memo)
                        
                        tableView.reloadData()
                        self.vc.navigationItem.title = memos.count == 0 ? "메모" : "\(memos.count)개의 메모"
                    }
                }
                tableView.reloadData()
            }
        }
    
        delete.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func dateGap(date: Date) -> Int {
        let date = date
        let calendar = Calendar.current
        let nowDate = Date()
        let gap = calendar.dateComponents([.day], from: date, to: nowDate)
        return gap.day ?? 9999
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let memos: Results<Memo>
        if searchBarIsEmpty {
            memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where { $0.isMarked == true }
        } else {
            guard let filteredMemo = filteredMemo else { return 0 }
             memos = filteredMemo.where { $0.isMarked == true }
        }
        switch section {
        case 0:
            return memos.count == 0 ? 0.01 : UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let markedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where { $0.isMarked == true }
        let notMarkedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where { $0.isMarked == false }
        var text = ""
        let nextVc = WriteViewController()
        UserDefaults.standard.set(true, forKey: UserDefault.pushedFromCell.rawValue)
        
        if searchBarIsEmpty {
            if indexPath.section == 0 {
                text = returnTitleContent(memos: markedMemos, indexPath: indexPath)
                nextVc.objectID = markedMemos[indexPath.row]._id

            } else {
                text = returnTitleContent(memos: notMarkedMemos, indexPath: indexPath)
                nextVc.objectID = notMarkedMemos[indexPath.row]._id
            }
        } else {
            // 검색에서 들어왔음
            UserDefaults.standard.set(true, forKey: UserDefault.showingKeyboard.rawValue)
            self.vc.navigationController?.navigationBar.topItem?.backButtonTitle = "검색"

            guard let filteredMemo = filteredMemo else { return }
            let filteredMarkedMemos = filteredMemo.where { $0.isMarked == true }
            let filteredNotMarkedMemos = filteredMemo.where { $0.isMarked == false }
            
            if indexPath.section == 0 {
                text = returnTitleContent(memos: filteredMarkedMemos, indexPath: indexPath)
                nextVc.objectID = filteredMarkedMemos[indexPath.row]._id
            } else {
                text = returnTitleContent(memos: filteredNotMarkedMemos, indexPath: indexPath)
                nextVc.objectID = filteredNotMarkedMemos[indexPath.row]._id
            }
        }
        self.vc.navigationController?.pushViewController(nextVc, animated: true)
        nextVc.mainView.textView.text = text
        }
    
    func returnTitleContent(memos: Results<Memo>, indexPath: IndexPath) -> String {
       let title = memos[indexPath.row].title
       let content = memos[indexPath.row].content != nil ? "\n\(memos[indexPath.row].content!)"  : ""
        return (title + content)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = self.tableView(tableView, titleForHeaderInSection: section)

        return label

    }
}

extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}

        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
