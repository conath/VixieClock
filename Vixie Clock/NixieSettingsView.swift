//
//  SettingsView.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 12.02.24.
//

import SwiftUI

struct NixieSettingsView: View {
    @ObservedObject var settings: NixieSettings
    @State var doneButtonAction: () -> Void
    @State var infoButtonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Vixie Clock Settings")
                .font(.title)
                .padding()
            
            Toggle(isOn: $settings.showSecondsDot) {
                Text("Show seconds indicator")
            }
            HStack {
                Text("Filament color (glow)")
                Spacer()
                Picker(selection: $settings.glowColor) {
                    ForEach(NixieColor.allCases, id: \.self) { color in
                        Text(color.rawValue)
                            .tag(color)
                    }
                } label: {
                    EmptyView() // adding text here did not work as of visionOS 1.0
                }
            }
            Toggle(isOn: $settings.showBg) {
                Text("Show background (hexagons)")
            }
            
            HStack {
                ShareLink(item: "https://apps.apple.com/app/id6477765117") {
                    Label {
                        EmptyView()
                    } icon: {
                        Image(systemName: "square.and.arrow.up") // share
                    }
                }
                
                Spacer()
                
                Button("Done", systemImage: "checkmark", action: doneButtonAction)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button {
                    infoButtonAction()
                } label: {
                    Label {
                        EmptyView()
                    } icon: {
                        Image(systemName: "info")
                    }
                }
            }
        }
        .padding()
    }
}
