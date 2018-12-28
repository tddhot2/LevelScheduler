//
//  SchedulerTableViewCell.swift
//  LevelScheduler
//
//  Created by USER on 17/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SchedulerTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleTextField: SkyFloatingLabelTextField!
    
    private var circleViews: [UIView] {
        var circleViews: [UIView] = []
        COLOR_ARRAY.forEach {
            let circleView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            circleView.layer.cornerRadius = circleView.bounds.width / 2
            circleView.backgroundColor = UIColor(hexcode: $0)
            circleViews.append(circleView)
        }
        return circleViews
    }
    
    func drawCell(_ row: Int) {
        titleTextField.placeholder = "\(row) 번째 타이틀 입력해주세요"
        titleTextField.title = "\(row) 번째 타이틀"
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.delegate = self
    }
    
    func getTitle() -> String {
        return titleTextField.text ?? ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if text.count < 1 {
                    floatingLabelTextField.errorMessage = "최소 한 글자 이상 입력해야 합니다."
                }
                else {
                    // The error message will only disappear when we reset it to nil or empty string
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
    }
}
