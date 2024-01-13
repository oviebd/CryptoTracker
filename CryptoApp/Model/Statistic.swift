//
//  Statistic.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 13/1/24.
//

import Foundation

struct Statistic: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?

    var changesInPercentage: Double {
        return percentageChange ?? 0
    }

    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
