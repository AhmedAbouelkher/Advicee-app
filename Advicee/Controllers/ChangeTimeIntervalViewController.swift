//
//  ChangeTimeIntervalViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

fileprivate enum PickerState {
    case auto
    case custom
}

class ChangeTimeIntervalViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var autoButton: UIButton!
    
    private var timeIntervalDate: Date?
    
    private var pickerState: PickerState!
    
    public var completion: ((Date?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Notification Time"
        
        navigationItem.leftBarButtonItem = .init(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .save, 
            target: self,
            action: #selector(didTapSave)
        )
        
        view.backgroundColor = ColorsManager.shared.currentColor
        
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        setupView()
        
        autoButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        autoButton.layer.cornerRadius = 10
        
        self.pickerState = UserDefaults.TimeIntervalSelectMode()
        print(self.pickerState!)
        if self.pickerState == .custom {
            timePicker.isEnabled = true
            autoButton.setTitle("Auto select time interval", for: .normal)
        } else {
            timePicker.isEnabled = false
            autoButton.setTitle("Custom time interval select", for: .normal)
        }
        
    }
    
    
    private func setupView() {
        guard let date = NotificationManager.shared.backgroundFetchDefaultDate else {
            let label = "30 minutes"
            timeLabel.text = label
            return
        }
        
        timeLabel.text = date.getString()
        timePicker.setDate(date, animated: true)
    }
    
    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapSave() {
        if let date = self.timeIntervalDate {
            NotificationManager.shared.setBackgroundFetchDefaultDate(with: date)
        }
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.completion?(self.timeIntervalDate)
        }
    }
    
    @IBAction
    private func timeDidChange(_ sender: UIDatePicker, event: UIEvent) {
        
        timeLabel.text = sender.date.getString()
        self.timeIntervalDate = sender.date
        
    }
    
    fileprivate func performTimeIntervalPicking() {
        if pickerState == .auto {
            pickerState = .custom
            timePicker.isEnabled = true
            autoButton.setTitle("Auto select time interval", for: .normal)
        } else {
            pickerState = .auto
            timePicker.isEnabled = false
            autoButton.setTitle("Custom time interval select", for: .normal)
        }
    }
    
    @IBAction
    private func didTapAuto(_ sender: UIButton) {
        performTimeIntervalPicking()
        UserDefaults.setTimeIntervalSelectMode(with: self.pickerState)
        
        if self.pickerState == .auto {
            self.timeIntervalDate = Date()
        }
    }
}

fileprivate extension UserDefaults {
    static func setTimeIntervalSelectMode(with state: PickerState) {
        let stateString = state == .auto ? "auto" : "custom"
        UserDefaults.standard.setValue(stateString, forKey: "PickerState")
    }
    
    static func TimeIntervalSelectMode() -> PickerState {
        guard let value = UserDefaults.standard.value(forKey: "PickerState") as? String else {
            return .custom
        }
        return value == "auto" ? .auto : .custom
    }
    
}
