//
//  ViewController.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit
import FontAwesomeKit

class NavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var adviceLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    private let leadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.startAnimating()
        spinner.isHidden = true
        return spinner
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(leadingIndicator)
        
        ColorsManager.shared.bind { color in
            UIView.animate(withDuration: 0.4) {
                self.view.backgroundColor = color
            }
        }
        
        
        let cogIcon = FAKFontAwesome.cogIcon(withSize: 25)?.getImage()
        
        settingsButton.setTitle(nil, for: .normal)
        settingsButton.setImage(cogIcon, for: .normal)
        
        
        let refreshIcon = FAKFontAwesome.refreshIcon(withSize: 25)?.getImage()
        
        refreshButton.setTitle(nil, for: .normal)
        refreshButton.setImage(refreshIcon, for: .normal)
        
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapRefresh))
        doubleTapGesture.numberOfTapsRequired = 2
        adviceLabel.isUserInteractionEnabled = true
        adviceLabel.addGestureRecognizer(doubleTapGesture)
        
        NotificationManager.shared.delegate = self
        NotificationManager.shared.requestPermission(in: self)
        
        loadNewAdvice()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        leadingIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        leadingIndicator.center = view.center
        
    }
    
    
    @IBAction func didTapSettingsButton(_ sender: UIButton) {
        
        var vc: SettingsViewController!
        
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "SettingsViewController")
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            vc = (storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController)
        }
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK:- Fetch Data From API-
    
    @IBAction func didTapRefresh(_ sender: UIButton) {
        loadNewAdvice()
        DispatchQueue.main.async {
            ColorsManager.shared.updateColor()
        }
    }
    
    private func loadNewAdvice() {
        adviceLabel.isHidden = true
        leadingIndicator.isHidden = false
        
        ApiCaller.shared.request(Advice.self) { result in
            switch result {
            case .success(let resp):
                DispatchQueue.main.async {
                    self.adviceLabel.text = resp.slip.advice
                    self.adviceLabel.isHidden = false
                    self.leadingIndicator.isHidden = true
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//MARK:- `NotificationManagerDelegate` impelementation-

extension HomeViewController: NotificationManagerDelegate {
    
    func didRecive(_ manager: NotificationManager, userData: [String : Any?]?) {
        guard let advice = userData?["advice"] as? Advice else {  return }
        DispatchQueue.main.async {
            self.adviceLabel.text = advice.slip.advice
            self.adviceLabel.isHidden = false
            self.leadingIndicator.isHidden = true
            ColorsManager.shared.updateColor()
        }
    }
    
    
}
