//
//  HapticsManager.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 28/08/25.
//

import Foundation
import SwiftUI

class HapticsManager {
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(
        type: UINotificationFeedbackGenerator.FeedbackType){
        generator
            .notificationOccurred(type)
    }
}
