//
//  GFRepoItemVC.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 29.10.2023.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }

    private func configureItems() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
