//
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            Path { path in
                let start = CGPoint(x: 0, y: proxy.size.height * 1)
                let end = CGPoint(x: proxy.size.width, y: proxy.size.height * 0.2)
                path.move(to: start)
                path.addLine(to: end)
            }
            .stroke(.blue, lineWidth: 2)
            
        }
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Helblo, gleen")
        }
        .frame(height: 200)
    }
}

#Preview {
    ContentView()
}
