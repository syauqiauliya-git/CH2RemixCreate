//
//  ChartView.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 20/04/26.
//

//
//  ChartView.swift
//  Challenge2
//
//  Created by Gleenryan on 17/04/26.
//

// MARK: - Charts

import Charts
import SwiftUI

struct PriceData: Identifiable {
    
    
    let id = UUID()
    let date: Date
    let price: Double
}

func makeDate(_ day: Int) -> Date {
    Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: day))!
}

let pricesData: [PriceData] = [
    PriceData(date: makeDate(1), price: 1000),
    PriceData(date: makeDate(2), price: 1500),
    PriceData(date: makeDate(3), price: 1200),
    PriceData(date: makeDate(4), price: 1800),
    PriceData(date: makeDate(5), price: 1600),
]

struct ChartView: View {
    var stockPrices: [PriceData]
    var width: CGFloat = 100
    var height: CGFloat = 100
    var body: some View {
        VStack{
            Chart(stockPrices) {item in
                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("price", item.price)
                )
                
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.2),
                            Color.green.opacity(0.005),
                            .clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                LineMark(x: .value("Revenue", item.date),
                         y: .value("Revenue", item.price)
                )
                .foregroundStyle(Color.green)
                
                let averagePrice = stockPrices.map { $0.price }.reduce(0, +) / Double(stockPrices.count)

                RuleMark(
                    y: .value("Average Price", averagePrice)
                )
                .foregroundStyle(Color.green)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [10,3]))
            }
        }
        .frame(width: width, height: height)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

