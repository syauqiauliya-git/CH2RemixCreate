//
//  StockCard.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//

import SwiftUI
import Charts
import Combine
struct StockCard: View {
    var stock: stockSummary
    var color: Color = .gray
    var icon: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            RoundedRectangle(cornerRadius: 35)
//                .fill(.gray)
            
//                .fill(.clear)
//                .stroke(.white, lineWidth: 1)
            
//                .fill(cardColors.randomElement() ?? .gray)
                .fill(color)
                .fill(.ultraThinMaterial)
//                .overlay(
//                        RoundedRectangle(cornerRadius: 40)
//                            .stroke(.white.opacity(0.3), lineWidth: 1)
//                    )
            VStack(alignment: .leading, ) {
                
                HStack {
                    Text(stock.symbol)
                    Spacer()
                    Text("\(stock.price, specifier: "%.2f")")
                }
                .font(.title2.bold())
                .foregroundStyle(.white)
                .fontDesign(.rounded)
                
                Text(stock.name)
                    .font(.caption)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                Chart {
                    ForEach(Array(stock.prices.enumerated()), id: \.offset) { index, price in
                        LineMark(
                            x: .value("Index", index),
                            y: .value("Price", price)
                        )
                        .foregroundStyle(.green)
                        
                        AreaMark(
                            x: .value("Index", index),
                            y: .value("price", price)
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
                    }
                    
                }
                .frame(height: 60)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                Spacer()
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            
            
            
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(.white)
                .padding()
        }
        .frame(height: 200)
        
        
    }
}
