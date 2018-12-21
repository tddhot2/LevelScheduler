//
//  ColorCollectionViewCell.swift
//  LevelScheduler
//
//  Created by USER on 17/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    override func prepareForReuse() {
        colorView.alpha = 0.2
    }
    
    func drawCell(cellIndex: Int, selectedIndex: Int, vc: StartSettingViewController) {
        colorView.backgroundColor = UIColor(hexcode: COLOR_ARRAY[cellIndex])
        colorView.layer.cornerRadius = 15
        
        let withDuration = (cellIndex == selectedIndex ? 0.2 : 0.0)
        UIView.animate(withDuration: withDuration) { [weak self] in
            self?.colorView.alpha = (cellIndex == selectedIndex ? 1.0 : 0.2)
        }
    }
    
}
