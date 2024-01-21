//
//  String.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 21/1/24.
//

import Foundation

extension String {
    func toDate(fromFormat: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        let date = formatter.date(from: self) ?? Date()
        return date
    }

    var removingHTMLOccurances: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
