//
//  StockCardContainer.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//
import SwiftUI
import Charts
import Combine

// MARK: - Screen
struct StockCardContainer: View {
    @StateObject private var vm: StockVM
    let color: Color
    let icon: String

    init(symbol: String, color: Color, icon: String) {
        self.color = color
        self.icon = icon
        _vm = StateObject(wrappedValue: StockVM(tickerSymbol: symbol))
    }

    var body: some View {
        Group {
            if let summary = vm.summary {
                StockCard(stock: summary, color: color, icon: icon)
            } else {
                ProgressView()
                    .frame(height: 200)
            }
        }
        .task {
            await vm.fetch()
        }
    }
}
