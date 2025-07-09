//
//  AppStoreReviewRequest.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 14.02.24.
//

import StoreKit
import UIKit

class AppStoreReviewRequest {
    static let DefaultsKeySettings = "numberOfTimesOpenedSettings"
    
    static func recordOpenedSettings() {
        let defaults = UserDefaults()
        let numOpenedSettings = defaults.integer(forKey: DefaultsKeySettings)
        defaults.setValue(numOpenedSettings + 1, forKey: DefaultsKeySettings)
    }
    
    static func requestReviewIfAppropriate() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        requestReviewIfAppropriate(in: scene)
    }
    
    static func requestReviewIfAppropriate(in scene: UIWindowScene) {
        let defaults = UserDefaults()
        let numOpenedSettings = defaults.integer(forKey: DefaultsKeySettings)
        guard numOpenedSettings > 1 else {
            return
        }
        
        // request for the review popup to be shown
        SKStoreReviewController.requestReview(in: scene)
    }
}
