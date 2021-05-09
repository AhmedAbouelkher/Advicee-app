//
//  SettingsViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit
import FontAwesomeKit

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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private var sections = [Section]()
    
    private let notificationTimeString = "Your new advice will be here every"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Settings"
        
        self.view.backgroundColor = ColorsManager.shared.currentColor
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        self.tableView.backgroundColor = self.view.backgroundColor
        
        navigationController?.navigationBar.tintColor = .white
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        let cogIcon = FAKFontAwesome.chevronLeftIcon(withSize: 30)?.getImage()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: cogIcon,
            style: .plain,
            target: self,
            action: #selector(didTapBack(_:))
        )
        
        ListTileCell.register(in: tableView)
        SwitchTableCell.register(in: tableView)
        tableView.separatorStyle = .none
        
        configureTableView()
    }
    
    
    @objc
    private func didTapBack(_ sender: UIButton) {    
        navigationController?.popViewController(animated: true)
    }
    
    private func configureTableView() {
        
        var label = "\(notificationTimeString) 30 minutes"
        if let date = NotificationManager.shared.backgroundFetchDefaultDate {
            label = "\(notificationTimeString) \(date.getString())"
        }
        
        let timerIcon = FAKFontAwesome.clockOIcon(withSize: 30).getImage()
        let notificationSection = Section(title: "", options: [
            Option(title: "Enable Notifications", type: .switchable),
            Option(title: "Set Notification Time",
                   subTitle: label,
                   icon: timerIcon, type: .listTile, handler: {
                self.openNotificationTimeIntervelPicker()
            }),
        ])
        
        
        let creditsSection = Section(title: "", options: [
            Option( title: "Legal" ),
            Option( title: "Credits"),
            Option( title: "Contact Us"),
        ])
        
        [
            notificationSection,
            creditsSection
        ].forEach { self.sections.append($0) }
    }
    
    private func openNotificationTimeIntervelPicker() {        
        
        var vc: ChangeTimeIntervalViewController!
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "ChangeTimeIntervalViewController")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            vc = (storyboard.instantiateViewController(withIdentifier: "ChangeTimeIntervalViewController") as! ChangeTimeIntervalViewController)
        }
        vc.completion = { [weak self] date in
            guard let self = self,
                  let date = date,
                  let option = self.sections[0].options.last else { return }
            
            var _option = option
            _option.subTitle = "\(self.notificationTimeString) \(date.getString())"
            self.sections[0].options.removeLast()
            self.sections[0].options.append(_option)
            self.tableView.reloadData()
        }
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let option = sections[indexPath.section].options[indexPath.row]
        
        switch option.type {
        case .standerd:
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            
            
            let label = cell.textLabel!
            label.textColor = .white
            label.text = option.title
            label.font = UIFont(name: "Roboto-Regular", size: 18.0)
            
            
            cell.accessoryType = .disclosureIndicator
            cell.imageView?.tintColor = .white
            cell.imageView?.image = option.icon
            
            return cell
        case .switchable:
            let cell = SwitchTableCell.dequeueFrom(tableView, forIndexPath: indexPath)
            cell.configure(
                with: SwitchTableCellViewModel(
                    title: option.title,
                    leadingIcon: FAKFontAwesome.bellIcon(withSize: 30)?.getImage(),
                    isOn: true
                )
            )
            cell.delegate = self
            return cell
        case .listTile:
            let cell = ListTileCell.dequeueFrom(tableView, forIndexPath: indexPath)
            cell.configure(
                with: ListTileCellViewModel(
                    title: option.title,
                    subTitle: option.subTitle,
                    leadingIcon: FAKFontAwesome.clockOIcon(withSize: 30)?.getImage()
                )
            )
            return cell
        case .plain:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler?()
        
    }
}


extension SettingsViewController: SwitchTableCellDelegate {
    func switchDidToggle(_ cell: SwitchTableCell, newValue value: Bool) {
        print(value)
    }
}
