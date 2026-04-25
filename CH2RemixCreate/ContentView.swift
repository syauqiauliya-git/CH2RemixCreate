
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI



struct ContentView: View {
    
    @State private var selectedTab = 0
    @State var isGraduated: Bool
    
    

    
    var body: some View {
        TabView(selection: $selectedTab) {
            LevelProgressionMap(isGraduated: .constant(isGraduated), selectedTab: $selectedTab)
                .tag(0)
                .tabItem {
                    Image(systemName: "map")
                    Text("Journey")
                }

            StockListScreen()
                .tag(1)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Stocks")
                }
                .disabled(!isGraduated)
                .overlay {
                    if !isGraduated {
                        ZStack {
                            Color.black.opacity(0.6)
                            VStack(spacing: 12){
                                Image(systemName: "lock.fill")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Finish your journey to unlock this feature")
                            }
                            
                        }
                        .ignoresSafeArea()
                    }
                }
        }
        
    }
    
}

#Preview {
    ContentView(isGraduated: false)
}

