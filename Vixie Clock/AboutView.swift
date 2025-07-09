//
//  AboutView.swift
//  Vixie Clock
//
//  Created by Quirin Parstorfer on 12.02.24.
//

import SwiftUI

fileprivate class Model: ObservableObject {
    @Published var data: String = ""
    
    init() {
        self.load(file: "NixieOneOFL")
    }
    
    func load(file: String) {
        if let filepath = Bundle.main.path(forResource: file, ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                DispatchQueue.main.async {
                    self.data = contents
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("File not found")
        }
    }
}

struct AboutView: View {
    @State var onClose: () -> Void
    @StateObject private var model = Model()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Text("About Vixie Clock")
                    .font(.largeTitle)
                    .padding()
                
                Text("© 2024 Quirin Parstorfer")
                    .font(.headline)
                    
                Divider()
                
                Text("Open Source Licenses")
                    .font(.title)
                    .padding()
                
                ScrollView(.vertical) {
                    Text("Nixie One Font")
                        .font(.headline)
                    Text(model.data)
                        .font(.footnote)
                        .padding(.bottom)
                }
            }
            
            Button("Close", systemImage: "xmark") {
                onClose()
            }
            .padding()
        }
    }
}

#Preview {
    AboutView(onClose: {})
}
