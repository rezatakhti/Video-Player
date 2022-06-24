//
//  UIViewExtensions.swift
//  Video Player
//
//  Created by Takhti, Gholamreza on 6/22/22.
//

import UIKit

extension UIView {
    @discardableResult
    func constrain(toView view: UIView, top: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil, bottom: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: top)
            constraints.append(topConstraint)
            view.addConstraint(topConstraint)
        }
        if let left = left {
            let leadingConstraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: left)
            constraints.append(leadingConstraint)
            view.addConstraint(leadingConstraint)
        }
        if let right = right {
            let trailingConstraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: right == 0 ? right : -right)
            constraints.append(trailingConstraint)
            view.addConstraint(trailingConstraint)
        }
        if let bottom = bottom {
            let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: bottom == 0 ? bottom : -bottom)
            constraints.append(bottomConstraint)
            bottomConstraint.priority = UILayoutPriority(999)
            view.addConstraint(bottomConstraint)
        }
        return constraints
    }

}

