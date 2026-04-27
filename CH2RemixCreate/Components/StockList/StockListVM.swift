//
//  StockListVM.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//
import SwiftUI
import Charts
import Combine

@MainActor
class StockListVM: ObservableObject {
    @Published var summaries: [StockSummary] = []
    
    func fetchAll() async {
        let symbols = stockListDummyData
        
        var temp: [StockSummary] = []
        
        for symbol in symbols {
            let vm = StockVM(tickerSymbol: symbol)
            await vm.fetch()
            
            if let summary = vm.summary {
                temp.append(summary)
            }
        }
        
        summaries = temp
    }
}
