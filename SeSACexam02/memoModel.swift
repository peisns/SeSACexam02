//
//  memoModel.swift
//  SeSACexam02
//
//  Created by Brother Model on 2022/09/02.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var title: String
    @Persisted var content: String?
    @Persisted var date = Date()
    @Persisted var isMarked: Bool = false

    convenience init(title: String, content: String?, date: Date){
        self.init()
        self.title = title
        self.content = content
        self.date = date
    }
}

