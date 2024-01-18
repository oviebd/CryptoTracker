//
//  HapticManager.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 18/1/24.
//

import Foundation
import UIKit

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notifications(type : UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
