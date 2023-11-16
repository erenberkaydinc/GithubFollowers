//
//  UITableView+Ext.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 16.11.2023.
//

import UIKit

extension UITableView {

    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }

    func removeExcessCells(){
        tableFooterView = UIView(frame: .zero)
    }
}
