//
//  UIView+Ext.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 16.11.2023.
//

import UIKit

extension UIView {

    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    func addSubViews(_ views: UIView...){
        for view in views{ addSubview(view) }
    }
}
