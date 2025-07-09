//
//  NixieColor.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 12.02.24.
//

import Foundation
import SwiftUI

enum NixieColor: String, CaseIterable, Identifiable {
    case orange, blue, cyan, red, pink
    var id: Self { self }
}

extension NixieColor {
    func toColor() -> Color {
        switch (self) {
        case .orange:
            return .orange
        case .blue:
            return .blue
        case .cyan:
            return .cyan
        case .red:
            return .red
        case .pink:
            return .pink
        }
    }
}
