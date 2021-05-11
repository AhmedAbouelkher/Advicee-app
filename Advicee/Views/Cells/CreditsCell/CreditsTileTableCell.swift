//
//  CreditsTileTableCell.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 11/05/2021.
//

import UIKit

struct CreditsTileTableCellViewModel {
    let label: String
    let subLabel: String
    let icon: UIImage?
    let url: URL?
}


class CreditsTileTableCell: UITableViewCell, IdentifiableCell {
    
    @IBOutlet weak var leadingIcon: UIImageView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    private var socialUrl: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        urlLabel.text = nil
        leadingIcon.image = nil
        subLabel.text = nil
        socialUrl = nil
    }

    typealias T = CreditsTileTableCellViewModel
    func configure(with model: CreditsTileTableCellViewModel) {        
        urlLabel.text = model.label
        leadingIcon.image = model.icon
        subLabel.text = model.subLabel
        socialUrl = model.url
    }
}
