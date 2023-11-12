//
//  UIViewController+Ext.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 25.10.2023.
//

import UIKit
import SafariServices

extension UIViewController {

    // To present a customized Alert on the main thread
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String){
        // Main Thread
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            // Presentation Style
            alertVC.modalPresentationStyle = .overFullScreen
            // Animation style ( Fade In )
            alertVC.modalTransitionStyle = .crossDissolve
            
            // Present the alertVC
            self.present(alertVC, animated: true)
        }
    }
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

}
