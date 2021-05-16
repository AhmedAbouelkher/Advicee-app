//
//  ContactUsViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 10/05/2021.
//

import UIKit
import FontAwesomeKit

class ContactUsViewController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var showInGitButton: UIButton!
    @IBOutlet weak var gitIconImageView: UIImageView!
    
    
    private var socialLinks = [SocialContactTableCellViewModel]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        versionLabel.text = "v\(appVersion)"
        
        contentLabel.text = "Advicee app is your fantastic way to stay motivated to go forward for knowing new fields to discover the world, a bit of good advice can change your way of thinking, so start now and learn more by reading and apply your new way of thinking to make you better."
        
        gitIconImageView.image = FAKFontAwesome.githubIcon(withSize: 30)?.getImage(with: nil, color: .black)
        
        SocialContactTableCell.register(in: tableView)
        
        configureTabelView()
    }
    
    private func configureTabelView() {
        
        //https://www.linkedin.com/in/ahmed-mahmoud-609b951a5/
        //https://github.com/AhmedAbouelkher
        //https://www.facebook.com/profile.php?id=100003753751915
        
        let size: CGFloat = 24
        let contacts = [
         
            SocialContactTableCellViewModel(
                label: "linkedin.com/AhmedMahmoud",
                icon: FAKFontAwesome.linkedinIcon(withSize: size)?.getImage(with: nil, color: UIColor(hex: "#0A66C2")),
                url: URL(string: "https://www.linkedin.com/in/ahmed-mahmoud-609b951a5/")
            ),
            SocialContactTableCellViewModel(
                label: "github.com/AhmedAbouelkher",
                icon: FAKFontAwesome.githubIcon(withSize: size)?.getImage(with: nil, color: .black),
                url: URL(string: "https://github.com/AhmedAbouelkher")
            ),
            SocialContactTableCellViewModel(
                label: "ahmedabouelkher1@gmail.com",
                icon: FAKFontAwesome.envelopeIcon(withSize: size)?.getImage(with: nil, color: .systemBlue),
                url: URL(string: "mailto:\("ahmedabouelkher1@gmail.com")")
            ),
            SocialContactTableCellViewModel(
                label: "facebook.com/AhmedMahmoud",
                icon: FAKFontAwesome.facebookFIcon(withSize: size)?.getImage(with: nil, color: UIColor(hex: "#0B84ED")),
                url: URL(string: "https://www.facebook.com/profile.php?id=100003753751915")
            ),
           
        ]
        
        socialLinks.append(contentsOf: contacts)
    }
    
    
    @IBAction private func didTapShowInGithub(_ sender: UIButton) {
        showUrlLaunchingConfirmationSheet(with:  URL(string: "https://github.com/AhmedAbouelkher/Advicee-app"), title: nil)
    }
}

extension ContactUsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialLinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SocialContactTableCell.dequeue(from: tableView, forIndexPath: indexPath)
        let link = socialLinks[indexPath.row]
        cell.configure( with: link)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let link = socialLinks[indexPath.row]
        showUrlLaunchingConfirmationSheet(with: link.url, title: nil)
    }
    
    private func showUrlLaunchingConfirmationSheet(with url: URL?, title: String?) {
        guard let url = url else { return }
        
        let vc = UIAlertController(
            title: "Launch Page",
            message: url.absoluteString,
            preferredStyle: .actionSheet
        )
        
        if url.absoluteString.contains("mailto") {
            let urlStringSplited = url.absoluteString.components(separatedBy: ":")
            vc.title = "Send E-mail"
            vc.message = urlStringSplited.last
            vc.addAction(UIAlertAction(title: "Open in Mail", style: .default, handler: { _ in
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            }))
            
        } else {
            vc.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { _ in
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            }))
        }
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(vc, animated: true)
    }
}
