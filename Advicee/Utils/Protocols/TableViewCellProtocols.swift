//
//  TableViewCellProtocols.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit

protocol IdentifiableCell: AnyObject {
    static var identifier: String { get }
    static var nib: UINib? { get }
    associatedtype T
    func configure(with model: T)
}

extension IdentifiableCell {
    static var identifier: String { "\(Self.self)" }
    
    static var nib: UINib? {
        if Bundle.main.path(forResource: identifier, ofType: "nib") != nil {
            return UINib(nibName: identifier, bundle: nil)
        }
        return nil
    }
}

extension IdentifiableCell where Self: UITableViewCell {
    static func register(in tableView: UITableView) {
        if let cellNib = nib {
            tableView.register(cellNib, forCellReuseIdentifier: identifier)
        } else {
            tableView.register(Self.self, forCellReuseIdentifier: identifier)
        }
    }
    
    static func dequeue(from tableView: UITableView, forIndexPath indexPath: IndexPath) -> Self {
        let anyCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let cell = anyCell as? Self else {
            fatalError("\(Self.self) is not registed for tableview")
        }
        return cell
    }
}
