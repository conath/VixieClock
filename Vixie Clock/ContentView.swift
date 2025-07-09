//
//  ContentView.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 11.02.24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var settings = NixieSettings()
    @State private var shownSettingsThisRun = false
    @State private var showSettings = false
    @State private var showInfo = false
    @State private var showCoachingOverlay = false
    
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            NixieView(settings: settings)
                .glassBackgroundEffect(displayMode: settings.showBg ? .implicit : .never)
                .onTapGesture {
                    withAnimation {
                        showSettings.toggle()
                        if showSettings {
                            shownSettingsThisRun = true
                            AppStoreReviewRequest.recordOpenedSettings()
                        }
                    }
                }
            
            if showCoachingOverlay && !showSettings && !shownSettingsThisRun {
                ZStack {
                    VStack {
                        Text("Welcome to Vixie Clock")
                            .font(.extraLargeTitle)
                            .padding()
                        Text("Tap to adjust color and more.")
                            .font(.largeTitle)
                            .padding()
                    }
                    .padding()
                }
                .onTapGesture {
                    withAnimation {
                        showSettings.toggle()
                        if showSettings {
                            shownSettingsThisRun = true
                            AppStoreReviewRequest.recordOpenedSettings()
                        }
                    }
                }
                .glassBackgroundEffect(displayMode: .implicit)
                .transition(.opacity)
            }
            
            // MARK:  - Modals
            
            // MARK:  Settings
            if showSettings {
                VStack {
                    NixieSettingsView(settings: settings, doneButtonAction: {
                        withAnimation {
                            showSettings = false
                            AppStoreReviewRequest.requestReviewIfAppropriate()
                        }
                    }, infoButtonAction: {
                        withAnimation {
                            showSettings = false
                            showInfo = true
                        }
                    })
                    .transition(.opacity)
                    .animation(.easeIn, value: showSettings)
                    .frame(maxWidth: 400)
                    .glassBackgroundEffect(displayMode: .implicit)
                    Spacer()
                }
            } else {
                // to appease SwiftUI layout engine... the window size changes otherwise when settings appears/disappears
                VStack {
                    Spacer()
                        .frame(width: 400)
                }
                .hidden()
            }
            
            // MARK:  Info
            if showInfo {
                VStack {
                    AboutView(onClose: {
                        withAnimation {
                            showInfo = false
                        }
                    })
                    .transition(.opacity)
                    .animation(.easeIn, value: showSettings)
                    .frame(maxWidth: 400)
                    .glassBackgroundEffect(displayMode: .implicit)
                    Spacer()
                }
            } else {
                // to appease SwiftUI layout engine... the window size changes otherwise when settings appears/disappears
                VStack {
                    Spacer()
                        .frame(width: 400)
                }
                .hidden()
            }
        }
        
        // MARK:  - Events
        .onReceive(timer, perform: { _ in
            if settings.isFirstRun {
                if !shownSettingsThisRun {
                    withAnimation {
                        showCoachingOverlay = true
                    }
                } else if shownSettingsThisRun {
                    // timer received again, hide the overlay
                    withAnimation {
                        showCoachingOverlay = false
                    }
                    // yes, this is what it takes to cancel a Timer
                    timer.upstream.connect().cancel()
                }
            } else {
                timer.upstream.connect().cancel()
            }
        })
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .background:
                // save the settings because app may quit soon
                settings.save()
                // hide modals
                showSettings = false
                showInfo = false
                break
            case .inactive:
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
    }
}
