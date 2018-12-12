//
//  RelamManager.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 12/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    static var shared = RealmManager()
    var relam: Realm {
        return try! Realm()
    }
    
    func setRealmFileByTableName(_ tableName: String) {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(tableName).realm")
        Realm.Configuration.defaultConfiguration = config
    }
    
    
}
