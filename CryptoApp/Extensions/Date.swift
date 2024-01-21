//
//  Date.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 21/1/24.
//

import Foundation

enum DateFormat: String {
    case coinGeco = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

extension Date {
    // "2021-03-13T20:49:26.606Z"
//    init(format: String) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        let date = formatter.date(from: format) ?? Date()
//        self.init(timeInterval: 0, since: date)
//    }
    
    init(coinGeckoString: String) {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           let date = formatter.date(from: coinGeckoString) ?? Date()
           self.init(timeInterval: 0, since: date)
       }

    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    func asShortDateString() -> String {
        return shortFormatter.string(from: self)
    }
}
