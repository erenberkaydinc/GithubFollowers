//
//  UserInfoVC.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 28.10.2023.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: GFDataLoadingVC {
    let scrollView = UIScrollView()
    let contentView = UIView()

    let headerView = UIView()
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    let dataLabel = GFBodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []

    var username: String!
    weak var delegate: UserInfoVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUI()

        getUserInfo()
    }

    private func configureViewController(){
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }

    private func getUserInfo() {
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) {[weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.configureUIElements(with: user)
                }
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }

    private func configureUIElements(with user: User) {
        self.add(childVC: GFUserInfoHeaderVC(user: user), to: self.headerView)

        self.add(childVC: GFRepoItemVC(user: user, delegate: self), to: self.itemViewOne)
        self.add(childVC: GFFollowerItemVC(user: user, delegate: self), to: self.itemViewTwo)

        self.dataLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
        self.dismissLoadingView()
    }

    private func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140

        itemViews = [headerView, itemViewOne, itemViewTwo,dataLabel]

        for itemView in itemViews {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dataLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dataLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

}
extension UserInfoVC: GFRepoItemVCDelegate {
    func didTapGetFollowers(for user: User) {
        // Dismiss VC
        // tell follower list screen the new user
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No Followers", message: "This user has no followers 😭", buttonTitle: "So sad")
            return
        }
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
}

extension UserInfoVC: GFFollowerItemVCDelegate {
    func didTapGitHubProfile(for user: User) {
        // Show safari view controller
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attachted to this user is invalid", buttonTitle: "Ok")
            return
        }

        presentSafariVC(with: url)
    }

}
