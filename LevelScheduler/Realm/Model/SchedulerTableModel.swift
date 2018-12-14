//
//  SchedulerTableModel.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 12/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import Foundation
import RealmSwift

class SchedulerTableModel: Object {
    @objc dynamic var schedulerId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var color: String = ""
    var cardList: List<EachSchedulerCardModel>? = nil
    
    override static func primaryKey() -> String? {
        return "schedulerId"
    }
}
