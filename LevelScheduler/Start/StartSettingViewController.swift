//
//  StartSettingViewController.swift
//  LevelScheduler
//
//  Created by USER on 11/12/2018.
//  Copyright © 2018 HYUNJIN. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import EMEmojiableBtn

private let DEFAULT_SCHEDULER_NUMBER: Int = 1
private let COLOR_ARRAY: [String] = ["ff4d3d", "8a58ff", "00dec7", "9e9ea9", "321421", "9922ee"]

class StartSettingViewController: UIViewController {
    
    // Outlet variables
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var settingTableView: UITableView!
    @IBOutlet private var dismissTapGestureRecognizer: UITapGestureRecognizer!
    
    // private variables
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
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // public variables
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
        cell.drawCell(indexPath.row + 1, vc: self)
        schedulerCellArray.append(cell)
        return cell
    }
}

// MARK: SchedulerTableViewCell
class SchedulerTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleTextField: SkyFloatingLabelTextField!
    @IBOutlet private weak var colorButton: EMEmojiableBtn!
    
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
    
    func drawCell(_ row: Int, vc: StartSettingViewController) {
        titleTextField.placeholder = "\(row) 번째 타이틀 입력해주세요"
        titleTextField.title = "\(row) 번째 타이틀"
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        titleTextField.delegate = self
        
        colorButton.layer.cornerRadius = colorButton.bounds.width / 2
        colorButton.backgroundColor = UIColor(hexcode: COLOR_ARRAY[0])
        setEMEMojiButtonResources(vc: vc)
    }
    
    func getTitle() -> String {
        return titleTextField.text ?? ""
    }
    
    private func setEMEMojiButtonResources(vc: StartSettingViewController) {
        colorButton.delegate = vc
        colorButton.dataset = circleViews
        
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

// MARK: SchedulerTableViewCell - EMEmojiableBtnDelegate
extension StartSettingViewController: EMEmojiableBtnDelegate {
    func emEmojiableBtnSingleTap(_ button: EMEmojiableBtn) {
        print("Single Tap")
    }
    
    func emEmojiableBtnCanceledAction(_ button: EMEmojiableBtn) {
        print("Cancle tap")
    }
    
    func emEmojiableBtn(_ button: EMEmojiableBtn, selectedOption index: UInt) {
        print("emEmojiableBtn tap")
    }
}

// MARK: SchedulerTableViewCell - UITextFieldDelegate
extension SchedulerTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
}

// MARK: ColorCollectionViewCell
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
