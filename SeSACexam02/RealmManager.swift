//
//  RealmManager.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/05.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    lazy var memos = realm.objects(Memo.self).sorted(byKeyPath: "date", ascending: false)
    
    func delete(memo: Memo) {
        try! realm.write {
        realm.delete(memo)
        }
    }
}
