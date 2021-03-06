//
//  CreditsViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 11/05/2021.
//

import UIKit
import FontAwesomeKit

class CreditsViewController: UIViewController {
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var creditLinks = [CreditsTileTableCellViewModel]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        contentLabel.text = "Thanks from our heart to all the people who created the tools that helped every developer to be better to be able to deliver the highest quality code."
        
        CreditsTileTableCell.register(in: tableView)
        
        configureTabelView()
    }
    
    
    private func configureTabelView() {
        let size: CGFloat = 24

        let creditsContacts = [
            CreditsTileTableCellViewModel(
                label: "public-apis",
                subLabel: "A collective list of free APIs",
                icon: FAKFontAwesome.githubIcon(withSize: size)?.getImage(with: nil, color: .black),
                url: URL(string: "https://github.com/public-apis/public-apis")
            ),
            CreditsTileTableCellViewModel(
                label: "Advice Slip JSON API",
                subLabel: "This API made the whole app worth it ♥️",
                icon: FAKFontAwesome.sitemapIcon(withSize: size)?.getImage(with: nil, color: .black),
                url: URL(string: "https://api.adviceslip.com/")
            ),
            CreditsTileTableCellViewModel(
                label: "notificationsounds.com",
                subLabel: "Gave us amazing notifiacation sounds closure-542, eventually-590, etc..",
                icon: FAKFontAwesome.globeIcon(withSize: size)?.getImage(with: nil, color: .black),
                url: URL(string: "https://notificationsounds.com/")
            ),
            CreditsTileTableCellViewModel(
                label: "fonts.google.com",
                subLabel: "For my favorite font ever Roboto",
                icon: FAKFontAwesome.googleIcon(withSize: size)?.getImage(
                    with: nil,
                    color: UIColor(hex: "#4285F4")
                ),
                url: URL(string: "https://fonts.google.com/specimen/Roboto?query=robot")
            )
            
        ]
        
        creditLinks.append(contentsOf: creditsContacts)
    }
    
}

extension CreditsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CreditsTileTableCell.dequeue(from: tableView, forIndexPath: indexPath)
        let link = creditLinks[indexPath.row]
        cell.configure( with: link)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = creditLinks[indexPath.row]
        showUrlLaunchingConfirmationSheet(with: link.url, title: nil)
    }
    
    private func showUrlLaunchingConfirmationSheet(with url: URL?, title: String?) {
        guard let url = url else { return }
        
        let vc = UIAlertController(
            title: "Launch Page",
            message: title ?? url.absoluteString,
            preferredStyle: .actionSheet
        )
        
        vc.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { _ in
            UIApplication.shared.open(url, options:[:], completionHandler: nil)
            
        }))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(vc, animated: true)
    }
    
}
