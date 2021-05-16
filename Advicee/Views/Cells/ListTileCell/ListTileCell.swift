//
//  SwitchTableCell.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

class ListTileCell: UITableViewCell, IdentifiableCell {
    
    private var model: ListTileCellViewModel?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    fileprivate func configureViews() {
        backgroundColor = .clear
        label.textColor = .white
        subLabel?.textColor = .white
    }
    
    public func setEnabled(enabled: Bool) {
        if enabled {
            label.textColor = .white
            subLabel.textColor = .white
            iconView.image = model?.leadingIcon?.getImage()
        } else {
            label.textColor = .lightGray
            subLabel.textColor = .lightGray
            iconView.image = model?.leadingIcon?.getImage(with: nil, color: .lightGray)
        }
        isUserInteractionEnabled = enabled
    }
    
    typealias T = ListTileCellViewModel
    public func configure(with model: ListTileCellViewModel) {
        self.model = model
        configureViews()
        label.text = model.title
        subLabel?.text = model.subTitle
        iconView.image = model.leadingIcon?.getImage()
        setEnabled(enabled: model.isEnabled)
    }
}
