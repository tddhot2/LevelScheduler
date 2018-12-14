//
//  UIColor+Extension.swift
//  LevelScheduler
//
//  Created by HYUNJIN on 12/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import UIKit


extension UIColor {
    convenience public init?(hexcode: String, alpha: CGFloat = 1.0) {
        let hexStr: String = hexcode.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr)
        var color: UInt32 = 0
        
        if !scanner.scanHexInt32(&color) {
            self.init()
            return nil
        }
        
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        self.init(red:r,green:g,blue:b,alpha:alpha)
    }
}

