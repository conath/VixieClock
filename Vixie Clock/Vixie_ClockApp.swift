//
//  Vixie_ClockApp.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 11.02.24.
//

import SwiftUI

@main
struct Vixie_ClockApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowResizability(.contentMinSize).windowStyle(.plain)
    }
}
