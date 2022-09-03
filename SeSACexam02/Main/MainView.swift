//
//  MainView.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/01.
//

import UIKit
import RealmSwift

final class MainView: BaseView {
    
    var vc = BaseViewController()
        
    let realm = try! Realm()
    
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
        return mainTableViewHeaderTitle.allCases[section].rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let markedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
                $0.isMarked == true
            }
            cell.titleLabel.text = markedMemos[indexPath.row].title
            
            let date = markedMemos[indexPath.row].date
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
            cell.dateLabel.text = newDate
            
            cell.contentLabel.text = markedMemos[indexPath.row].content!.isEmpty ? "추가 텍스트 없음" : markedMemos[indexPath.row].content
        } else {
            let notMarkedMemos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false).where {
                $0.isMarked == false
            }
            cell.titleLabel.text = notMarkedMemos[indexPath.row].title
            
            let date = notMarkedMemos[indexPath.row].date
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
            cell.dateLabel.text = newDate
            
            cell.contentLabel.text = notMarkedMemos[indexPath.row].content!.isEmpty ? "추가 텍스트 없음" : notMarkedMemos[indexPath.row].content
        }
                
        return cell
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
                    tableView.reloadData()
                }
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
}

