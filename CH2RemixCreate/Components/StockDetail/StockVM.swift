//
//  StockVM.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//

import SwiftUI
import Charts
import Combine
//biar kerjain ini di mainthread
@MainActor
//pake class karena dia observable object
class StockVM: ObservableObject {
    //published ini buat kalo datanya berubah, dia bakal update the UI
    @Published var prices: [PricePoint] = []
    @Published var companyName: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var selectedMode: ChartMode = .sixMonth
    @Published var latestVolume: Int = 0
    
    let tickerSymbol:String
    init(tickerSymbol: String) {
            self.tickerSymbol = tickerSymbol
        }
    
    var summary: stockSummary? {
        guard let latestPrice = prices.last?.price else { return nil }
        
        return stockSummary(
            symbol: tickerSymbol,
            name: companyName,
            price: latestPrice,
            prices: prices.map { $0.price },
            color: .gray
        )
    }

    func fetch() async {
        
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(tickerSymbol)?interval=\(selectedMode.interval)&range=\(selectedMode.range)") else {
            errorMessage = "URL tidak valid."
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(APIResponse.self, from: data)

            guard let r = decoded.chart.result.first else {
                errorMessage = "Data tidak ditemukan."
                isLoading = false
                return
            }

            companyName = r.meta.longName ?? r.meta.symbol ?? "Unknown"

            prices = zip(r.timestamp, r.indicators.quote[0].close)
                .compactMap { t, p in
                    guard let p else { return nil }
                    return PricePoint(
                        date: Date(timeIntervalSince1970: TimeInterval(t)),
                        price: p
                    )
                }
            
            let quote = r.indicators.quote[0]
            latestVolume = quote.volume.compactMap { $0 }.last ?? 0

        } catch {
            errorMessage = "Gagal memuat data: \(error.localizedDescription)"
            print("ERROR:", error)
        }

        isLoading = false
    }
}
