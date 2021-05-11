//
//  Cell.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 11/05/2021.
//

import UIKit

class SocialContactTableCell: UITableViewCell, IdentifiableCell {
    
    private var socialUrl: URL?
    
    private let leadingIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private class UIUnderLinelabel: UILabel {
        override var text: String? {
            didSet {
                guard let text = text else { return }
                let attributedText = NSMutableAttributedString(string: text)
                let range = NSRange(location: 0, length: text.count)
                attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
                self.attributedText = attributedText
                
            }
        }
    }
    
    private let urlLabel: UIUnderLinelabel = {
        let label = UIUnderLinelabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Roboto-Regular", size: 17.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        contentView.addSubview(leadingIcon)
        contentView.addSubview(urlLabel)
        
        
        leadingIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        NSLayoutConstraint.activate([
            leadingIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leadingIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            //https://stackoverflow.com/questions/31334017/how-can-i-set-aspect-ratio-constraints-programmatically-in-ios
//            leadingIcon.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0)
        ])
        
        urlLabel.anchor(
            top: contentView.topAnchor,
            leading: leadingIcon.trailingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 5)
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        urlLabel.text = nil
        leadingIcon.image = nil
        socialUrl = nil
    }

    typealias T = SocialContactTableCellViewModel
    func configure(with model: SocialContactTableCellViewModel) {
        if let title = model.label {
            urlLabel.text = title
        } else if let url = model.url {
            urlLabel.text = url.absoluteString
            self.socialUrl = url
        }
        leadingIcon.image = model.icon
        
    }
}
