//
//  LCDView.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 11.02.24.
//

import SwiftUI

struct NixieView: View {
    class ClockState: ObservableObject {
        private let calendar = Calendar.current
        @Published var hourTen: Int
        @Published var hourOne: Int
        @Published var minuteTen: Int
        @Published var minuteOne: Int
        @Published var showDot: Bool

        init(showSecondsDot: Bool) {
            let currentDate = Date()
            let hour = calendar.component(.hour, from: currentDate)
            hourTen = Int(hour / 10)
            hourOne = Int(hour % 10)
            let minute = calendar.component(.minute, from: currentDate)
            minuteTen = Int(minute / 10)
            minuteOne = minute % 10
            let isEvenSecond = calendar.component(.second, from: currentDate) % 2 == 0
            showDot = isEvenSecond && showSecondsDot
        }
        
        func update(showSecondsDot: Bool) {
            let currentDate = Date()
            let hour = calendar.component(.hour, from: currentDate)
            hourTen = Int(hour / 10)
            hourOne = Int(hour % 10)
            let minute = calendar.component(.minute, from: currentDate)
            minuteTen = Int(minute / 10)
            minuteOne = minute % 10
            let isEvenSecond = calendar.component(.second, from: currentDate) % 2 == 0
            showDot = isEvenSecond && showSecondsDot
        }
    }
    
    @ObservedObject var settings: NixieSettings
    @StateObject private var state = ClockState(showSecondsDot: false)
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        let fontSize = UIFont.preferredFont(forTextStyle: .extraLargeTitle).pointSize * 40
        let font = Font.custom("NixieOne", size: fontSize)
        
        let glowColor = settings.glowColor.toColor()
        return ZStack {
            HStack {
                digitView(font, compare: state.hourTen, glow: glowColor)
                digitView(font, compare: state.hourOne, glow: glowColor)
                Text(".")
                    .font(font)
                    .foregroundColor(state.showDot ? glowColor : .clear)
                    .animation(.easeIn, value: state.showDot)
                digitView(font, compare: state.minuteTen, glow: glowColor)
                digitView(font, compare: state.minuteOne, glow: glowColor)
            }
            .background {
                if (settings.showBg) {
                    Image("HexagonPatternSmall")
                        .blendMode(.darken)
                }
            }
            .minimumScaleFactor(0.01)
            .scaledToFit()
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .clipped()
        .onReceive(timer) { _ in
            withAnimation {
                state.update(showSecondsDot: settings.showSecondsDot)
            }
        }
    }
    
    private func digitView(_ font: Font, compare compareDigit: Int, glow glowColor: Color, off offColor: Color = Color(hue: 0, saturation: 0, brightness: 0, opacity: 0.1)) -> some View {
        return ZStack {
            ForEach((0..<10), id: \.self) { digit in
                Text(digit.description)
                    .font(font)
                    .frame(depth: CGFloat(digit))
                    .foregroundColor(compareDigit == digit ? glowColor : offColor)
            }
        }
    }
}

#if targetEnvironment(simulator)
#Preview(windowStyle: .plain) {
    NixieView(settings: NixieSettings())
}
#endif
