//
//  Extensions.swift
//  Advicee
//
//  Created by Ahmed Mahmoud on 08/05/2021.
//

import UIKit
import FontAwesomeKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        let frame = self.frame
        return frame.size.height + frame.origin.y
    }
    
    public func bottomFrameAncher(to view: UIView, constant: CGFloat? = nil) {
        var constant: CGFloat!
        if constant == nil {
            constant = height
        }
        frame.origin.y = view.height - constant!
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    
    public var right: CGFloat {
        let frame = self.frame
        return frame.origin.x + frame.size.width
    }
    
    public func makeCirculer() -> Void {
        let width = frame.width
        layer.cornerRadius = width / 2
    }
    
    
    public enum CenterType {
        case x
        case y
        case all
    }
    
    public func setCenter(to view: UIView, with type: CenterType = .all) {
        let center = view.center
        switch type {
        case .x:
            self.center.x = center.x
        case .y:
            self.center.y = center.y
        case .all:
            self.center = center
        }
    }
    
    public func setBorder(with width: CGFloat, color: UIColor) {
        self.layer.masksToBounds = true
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    

    
    public func showProgressIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView()
            if #available(iOS 13.0, *) {
                spinner.style = .large
            } else {
                spinner.style = .whiteLarge
            }
            spinner.hidesWhenStopped = true
            return spinner
        }()
        
        self.addSubview(indicator)
        indicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        indicator.setCenter(to: self)
        DispatchQueue.main.async {  indicator.startAnimating()  }
        return indicator
    }
    
    public func stopProgressIndicator() {
        let spinner = self.subviews.first { view -> Bool in
            if let _ = view as? UIActivityIndicatorView {
                return true
            }
            return false
        }
        guard let indicator = spinner as? UIActivityIndicatorView else {
            fatalError("\(Self.self) has no spinner")
        }
        DispatchQueue.main.async {  indicator.stopAnimating() }
    }
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


extension FAKIcon {
    public func getImage(with size: CGFloat? = nil, color: UIColor? = nil) -> UIImage {
        self.addAttribute(NSAttributedString.Key.foregroundColor.rawValue, value: color ?? UIColor.white)
        let size = size ?? CGFloat(iconFontSize)
        return self.image(with: CGSize(width: size, height: size))
    }
}
