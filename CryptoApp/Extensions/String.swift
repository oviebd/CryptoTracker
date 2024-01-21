//
//  String.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 21/1/24.
//

import Foundation

extension String{
    
    func toDate(fromFormat : String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
       // let date = formatter.date(from: fromFormat) ?? Date()
       
        let date = formatter.date(from: self) ?? Date()
        return date
       // self.init(timeInterval: 0, since: date)
    }
    
}
