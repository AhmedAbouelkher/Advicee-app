//
//  SettingTableModels.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 10/05/2021.
//

import UIKit

enum SectionOptionType {
    case standerd
    case switchable
    case plain
    case listTile
}

struct Section {
    let title:String
    var options: [Option]
}

struct Option {
    let title: String
    let titleColor: UIColor?
    let handler: (() -> Void)?
    let icon: UIImage?
    let type: SectionOptionType
    var subTitle: String?
    
    init(title: String,
         subTitle: String? = nil,
         icon: UIImage? = nil,
         type: SectionOptionType = .standerd,
         titleColor: UIColor? = .white,
         handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.subTitle = subTitle
        self.handler = handler
        self.titleColor = titleColor
        self.type = type
        self.icon = icon
    }
}
