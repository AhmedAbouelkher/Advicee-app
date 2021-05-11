//
//  ChangeTimeIntervalViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

class ChangeTimeIntervalViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    private var timeIntervalDate: Date?
    
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
}
