//
//  EachSchedulerCardModel.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 12/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import Foundation
import RealmSwift

class EachSchedulerCardModel: RealmCollectionValue {
    static func == (lhs: EachSchedulerCardModel, rhs: EachSchedulerCardModel) -> Bool {
        return lhs.cardTitle == rhs.cardTitle
    }
    
    @objc dynamic var cardTitle: String = ""
    @objc dynamic var cardContent: String = ""
}
