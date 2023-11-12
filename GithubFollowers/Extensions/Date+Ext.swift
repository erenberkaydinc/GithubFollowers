//
//  Date+Ext.swift
//  GithubFollowers
//
//  Created by Eren Berkay Dinç on 29.10.2023.
//

import Foundation

extension Date {

    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
