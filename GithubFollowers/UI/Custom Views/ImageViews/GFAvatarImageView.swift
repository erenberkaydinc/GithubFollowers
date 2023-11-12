//
//  GFAvatarImageView.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 25.10.2023.
//

import UIKit

class GFAvatarImageView: UIImageView {
    let placeholderImage = Images.placeholder
    let cache            = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
}
