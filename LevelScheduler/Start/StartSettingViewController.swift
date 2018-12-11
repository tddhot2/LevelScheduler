//
//  StartSettingViewController.swift
//  LevelScheduler
//
//  Created by USER on 11/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

private let DEFAULT_SCHEDULER_NUMBER: Int = 1
private let COLOR_COLLECTION_NUMBER: Int = 10
private let COLOR_ARRAY: [UIColor] = [.red, .black, .blue, .gray, .brown, .yellow, .purple, .cyan, .magenta, .green]

class StartSettingViewController: UIViewController {
    
    // Outlet variables
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var settingTableView: UITableView!
    
    // private variables
    private var schedulerNumber: Int = DEFAULT_SCHEDULER_NUMBER {
        didSet {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let `self` = self else { return }
                self.numberLabel.alpha = 0.0
                self.numberLabel.text = "\(self.schedulerNumber)"
                UIView.animate(withDuration: 0.5) {
                    self.numberLabel.alpha = 1.0
                }
            }
            settingTableView.reloadData()
        }
    }
    
    private lazy var __once: () = {
       schedulerNumber = DEFAULT_SCHEDULER_NUMBER
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = __once
    }
}

// MARK: Selector
extension StartSettingViewController {
    @IBAction func didDownButtonTapped(_ sender: UIButton) {
        guard schedulerNumber - 1 > 0 else { return }
        schedulerNumber -= 1
    }
    
    @IBAction func didUpButtonTapped(_ sender: UIButton) {
        schedulerNumber += 1
    }
}

// MARK: Scheduler Setting Table View Delegate
extension StartSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedulerNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.schedulerTableCell.identifier) as! SchedulerTableViewCell
        cell.drawCell(indexPath.row + 1)
        return cell
    }
}

// MARK: Color Collection View Delegate
extension StartSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return COLOR_COLLECTION_NUMBER
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.colorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else { return UICollectionViewCell() }
        cell.drawCell(COLOR_ARRAY[indexPath.row])
        return cell
    }
    
    
}

// MARK: SchedulerTableViewCell
class SchedulerTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var colorCollectionView: UICollectionView!
    
    func drawCell(_ row: Int) {
        titleTextField.placeholder = "\(row) 번째 타이틀 입력해주세요"
        titleTextField.title = "\(row) 번째 타이틀"
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    func drawCell(_ color: UIColor) {
        colorView.backgroundColor = color
        colorView.layer.cornerRadius = 15
    }
}
