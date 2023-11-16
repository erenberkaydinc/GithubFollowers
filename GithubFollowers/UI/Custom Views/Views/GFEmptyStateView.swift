//
//  GFEmptyStateView.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 28.10.2023.
//

import UIKit

class GFEmptyStateView: UIView {

    let messageLabel = GFTitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   convenience init(message: String) {
        self.init(frame: .zero)
        self.messageLabel.text = message
    }

    private func configure() {
        addSubViews(messageLabel,logoImageView)
        configureMessageLabel()
        configureLogoImageView()
    }

    private func configureMessageLabel() {
        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel

        let labelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? -90 : -150

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: labelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            ])
    }

    private func configureLogoImageView() {
        logoImageView.image = Images.emptyLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 40

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3), // making image 1.3 larger than its normal size
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3), // we try to make square image
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170), //Trailing-Right
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor   , constant: logoBottomConstant),
        ])
    }

}

