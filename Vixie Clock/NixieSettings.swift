//
//  NixieSettings.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 12.02.24.
//

import Foundation
import Combine

class NixieSettings: ObservableObject {
    let isFirstRun: Bool
    @Published var showBg: Bool
    @Published var showSecondsDot: Bool
    @Published var glowColor: NixieColor
    
    init() {
        let defaults = UserDefaults.standard
        let savedOnce = defaults.bool(forKey: .savedOnceKey)
        if (savedOnce) {
            isFirstRun = false
            _showBg = Published<Bool>(initialValue: defaults.bool(forKey: .nixieShowBgKey))
            _showSecondsDot = Published<Bool>(initialValue: defaults.bool(forKey: .nixieShowSecondsDotKey))
            var initialGlowColor = NixieColor.orange
            if let storedColor = defaults.string(forKey: .nixieGlowColorKey) {
                initialGlowColor = NixieColor(rawValue: storedColor) ?? .orange
            }
            _glowColor = Published<NixieColor>(initialValue: initialGlowColor)
        } else {
            // else use the default values
            print("using default settings")
            isFirstRun = true
            showBg = true
            showSecondsDot = true
            glowColor = .orange
        }
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: .savedOnceKey)
        defaults.set(showBg, forKey: .nixieShowBgKey)
        defaults.set(showSecondsDot, forKey: .nixieShowSecondsDotKey)
        defaults.set(glowColor.rawValue, forKey: .nixieGlowColorKey)
        defaults.synchronize()
    }
}

fileprivate extension String {
    static let savedOnceKey = "savedOnce"
    static let nixieShowBgKey = "nixieShowBg"
    static let nixieShowSecondsDotKey = "nixieShowSecondsDot"
    static let nixieGlowColorKey = "nixieGlowColor"
}
