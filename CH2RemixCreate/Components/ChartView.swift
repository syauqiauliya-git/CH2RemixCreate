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

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let revenue: Double
}

let salesData: [SalesData] = [
    SalesData(month: "Jan", revenue: 1000),
    SalesData(month: "Feb", revenue: 1500),
    SalesData(month: "Mar", revenue: 1200),
    SalesData(month: "Apr", revenue: 1800),
]

struct ChartView: View {
    var width: CGFloat = 100
    var height: CGFloat = 100
    var body: some View {
        VStack{
            Chart(salesData) {item in
                AreaMark(
                    x: .value("Month", item.month),
                    y: .value("Revenue", item.revenue)
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
                
                LineMark(x: .value("Revenue", item.month),
                         y: .value("Revenue", item.revenue)
                )
                .foregroundStyle(Color.green)
                
                RuleMark(
                    y: .value("Current Price", 1200)
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

