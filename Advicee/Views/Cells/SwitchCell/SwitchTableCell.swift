//
//  SwitchTableCell.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

protocol SwitchTableCellDelegate: AnyObject {
    func switchDidToggle(_ cell: SwitchTableCell, newValue value: Bool)
}

class SwitchTableCell: UITableViewCell, IdentifiableCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var _switch: UISwitch!
    
    public weak var delegate: SwitchTableCellDelegate?
    
    fileprivate func configureViews() {
        backgroundColor = .clear
        label.textColor = .white
        iconView.tintColor = .white
    }
    
    typealias T = SwitchTableCellViewModel
    public func configure(with model: SwitchTableCellViewModel) {
        configureViews()
        label.text = model.title
        iconView.image = model.leadingIcon
        _switch.setOn(model.isOn, animated: false)
    }
    
    @IBAction private func didTapSwitch(_ sender: UISwitch) {
        delegate?.switchDidToggle(self, newValue: sender.isOn)
    }
}
