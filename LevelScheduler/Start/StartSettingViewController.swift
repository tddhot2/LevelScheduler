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
public let COLOR_ARRAY: [String] = ["ff4d3d", "8a58ff", "00dec7", "9e9ea9", "321421", "9922ee"]

class StartSettingViewController: UIViewController {
    
    private lazy var __once: () = {
        schedulerNumber = DEFAULT_SCHEDULER_NUMBER
        dismissTapGestureRecognizer.isEnabled = false
        
        let center = NotificationCenter.default
        let notiArr: [Notification.Name : Selector] = [
            UIResponder.keyboardDidShowNotification:#selector(didKeyboardWillShow(_:)),
            UIResponder.keyboardDidHideNotification:#selector(didKeyboardWillHide(_:)),
            ]
        notiArr.forEach { (noti, selector) in
            center.addObserver(self, selector: selector, name: noti, object: nil)
        }
    }()
    
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var settingTableView: UITableView!
    @IBOutlet private var dismissTapGestureRecognizer: UITapGestureRecognizer!
    
    private var schedulerNumber: Int = DEFAULT_SCHEDULER_NUMBER {
        didSet {
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let `self` = self else { return }
                self.numberLabel.alpha = 0.0
                self.numberLabel.text = "\(self.schedulerNumber)"
                UIView.animate(withDuration: 0.2) {
                    self.numberLabel.alpha = 1.0
                }
            }
            schedulerCellArray.removeAll()
            settingTableView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var selectedColorIndexArray: [Int] = [0]
    var schedulerCellArray: [SchedulerTableViewCell] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = __once
    }
    
    private func moveSettingTableViewContentOffset(_ y: CGFloat = 0) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.settingTableView.contentOffset = CGPoint(x: 0, y: y)
            self.settingTableView.layoutIfNeeded()
        })
    }
}

// MARK: Selector
extension StartSettingViewController {
    @IBAction func didDownButtonTapped(_ sender: UIButton) {
        guard schedulerNumber - 1 > 0 else { return }
        schedulerNumber -= 1
        selectedColorIndexArray.removeLast()
    }
    
    @IBAction func didUpButtonTapped(_ sender: UIButton) {
        schedulerNumber += 1
        selectedColorIndexArray.append(0)
    }
    
    @IBAction func didResetButtonTapped(_ sender: UIButton) {
        schedulerNumber = DEFAULT_SCHEDULER_NUMBER
        selectedColorIndexArray.removeAll()
        selectedColorIndexArray.append(0)
    }
    
    @IBAction func didOkButtonTapped(_ sender: UIButton) {
        let titleArr = schedulerCellArray.compactMap { return $0.getTitle() }.sorted()
        for i in 0..<titleArr.count - 1 {
            if titleArr[i] == titleArr[i+1] {
                return
            }
        }
        RealmManager.shared.setRealmFileByTableName("Scheduler")
        for i in titleArr.enumerated() {
            let object = SchedulerTableModel()
            object.schedulerId = i.offset
            object.title = i.element
            object.color = COLOR_ARRAY[i.offset]
            object.cardList = nil
            RealmManager.shared.write(object)
        }
        
        User.shared.isSchedulerInitFnished = true
        
        guard let homeVC = R.storyboard.home.homeViewController() else { return }
        present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func didDismissTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func didKeyboardWillShow(_ notification: Notification) {
        dismissTapGestureRecognizer.isEnabled = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let y = (UIScreen.main.bounds.height - keyboardFrame.cgRectValue.height) - (view.convert(settingTableView.frame, from: view).minY + settingTableView.contentSize.height)
            moveSettingTableViewContentOffset((y > 0 ? 0 : -y))
        }
        
    }
    
    @objc func didKeyboardWillHide(_ notification: Notification) {
        dismissTapGestureRecognizer.isEnabled = false
        moveSettingTableViewContentOffset()
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
        schedulerCellArray.append(cell)
        return cell
    }
}

// MARK: Color Collection View Delegate
extension StartSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return COLOR_ARRAY.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.colorCollectionViewCell, for: indexPath) else {
            return UICollectionViewCell()
        }
        cell.drawCell(cellIndex: indexPath.row, selectedIndex: selectedColorIndexArray[getCurrentSchedulerIndex(collectionView)], vc: self)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorIndexArray[getCurrentSchedulerIndex(collectionView)] = indexPath.row
        collectionView.reloadData()
    }
    
    private func getCurrentSchedulerIndex(_ collectionView: UICollectionView) -> Int {
        var index = 0
        schedulerCellArray.forEach { tableCell in
            for i in 0..<schedulerCellArray.count {
                if tableCell == collectionView.superview?.superview {
                    index = i
                }
            }
        }
        return index
    }
}

// MARK: SchedulerTableViewCell - UITextFieldDelegate
extension SchedulerTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}
