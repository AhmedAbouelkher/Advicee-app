//
//  SwitchTableCell.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

class ListTileCell: UITableViewCell, IdentifiableCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var subLabel: UILabel?
    @IBOutlet weak var iconView: UIImageView! 
    

    fileprivate func configureViews() {
        backgroundColor = .clear
        label.textColor = .white
        subLabel?.textColor = .white
        iconView.tintColor = .white
    }
    
    typealias T = ListTileCellViewModel
    public func configure(with model: ListTileCellViewModel) {
        configureViews()
        label.text = model.title
        subLabel?.text = model.subTitle
        iconView.image = model.leadingIcon
    }
}
