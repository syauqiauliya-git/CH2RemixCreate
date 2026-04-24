
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI


struct ContentView: View {
    
    @State var isGraduated: Bool
    
    var body: some View {
        if (isGraduated) {
            StockListScreen(stocks: ["RBLX", "NFLX", "WBD", "AAPL", "TSLA"], icon: ["gamecontroller.fill",
                                                                                    "tv.fill",
                                                                                    "building.2.fill",
                                                                                    "applelogo",
                                                                                    "car.fill"])
        } else {
            LevelProgressionMap(isGraduated: $isGraduated)
        }
    }
    
}

#Preview {
    ContentView(isGraduated: false)
}

