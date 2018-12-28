//
//  User.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 28/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import Foundation

// UserDefaults Standard Key
private let isSchedulerInitFnishedKey = "isSchedulerInitFnished"

public final class User {
    public static let shared = User()
    
    public var isSchedulerInitFnished: Bool {
        get {
            UserDefaults.standard.register(defaults: [isSchedulerInitFnishedKey: ""])
            return UserDefaults.standard.bool(forKey: isSchedulerInitFnishedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isSchedulerInitFnishedKey)
        }
    }
}
