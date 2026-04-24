//
//  StockDetailSheetScreen.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 21/04/26.
//

import SwiftUI
import Charts
import Combine

struct PricePoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}


struct APIResponse: Codable {
    let chart: APIChart
}

struct APIChart: Codable {
    let result: [ChartResult]
}

struct ChartResult: Codable {
    let meta: Meta
    let timestamp: [Int]
    let indicators: Indicators
}

struct Meta: Codable {
    let longName: String?
    let symbol: String?
}

struct Indicators: Codable {
    let quote: [Quote]
}

struct Quote: Codable {
    let close: [Double?]
    let volume: [Int?]
}

func formatVolume(_ value: Int) -> String {
    let num = Double(value)
    
    switch num {
    case 1_000_000_000...:
        return String(format: "%.1fB", num / 1_000_000_000)
    case 1_000_000...:
        return String(format: "%.1fM", num / 1_000_000)
    case 1_000...:
        return String(format: "%.1fK", num / 1_000)
    default:
        return "\(value)"
    }
}

enum ChartMode: String, CaseIterable, Identifiable {
    case sixMonth = "6M"
    case oneYear = "1Y"
    case max = "MAX"
    case summary = "Summary"
    
    var id: String { rawValue }
    
    var interval: String {
        switch self {
        case .sixMonth: return "1d"
        case .oneYear: return "1mo"
        case .max: return "1mo"
        case .summary: return "1d"
        }
    }
    
    var range: String {
        switch self {
        case .sixMonth: return "6mo"
        case .oneYear: return "1y"
        case .max: return "max"
        case .summary: return "1m"
        }
        
    
    }
    
    var axisFormat: Date.FormatStyle {
            switch self {
            case .sixMonth:
                return .dateTime.month()
            case .oneYear:
                return .dateTime.month()
            case .max:
                return .dateTime.year()
            case .summary:
                return .dateTime.month()
            }
        }
}







struct StockDetailSheet: View {
    @StateObject private var vm: StockVM
    @Environment(\.dismiss) var dismiss
    
    let tickerSymbol: String
    let color: Color
    let icon: String

    init(tickerSymbol: String, color: Color, icon: String) {
        self.tickerSymbol = tickerSymbol
        self.color = color
        self.icon = icon
        _vm = StateObject(wrappedValue: StockVM(tickerSymbol: tickerSymbol))
    }

    var body: some View {
        
        NavigationStack{
            
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Image(systemName: icon)
                        .font(.system(size: 40))
                        .padding(12)
                    VStack (alignment: .leading){
                        Text(tickerSymbol)
                            .font(.system(size: 50))
                        Text(vm.companyName)
                            .foregroundStyle(.gray)
                    }
                    .bold()
                    
                }
                .frame(maxWidth: .infinity)
                HStack{
                    Text("\(vm.prices.last?.price ?? 0, specifier: "%.2f")")
                        .font(.system(size: 35))
                    Text("2.75%")
                        .foregroundStyle(.green)
                    
                }
                .padding(15)
                
                
                StockDetailChart(vm: vm)
                    .task {
                        await vm.fetch()
                    }
                HStack{
                    StockDetailInfo(detailTitle: "High", detailValue: String(format: "%.2f", vm.prices.map(\.price).max() ?? 0))
                    StockDetailInfo(detailTitle: "Vol", detailValue: formatVolume(vm.latestVolume))
                }
                .padding(.horizontal, 10)
                HStack{
                    StockDetailInfo(detailTitle: "Low", detailValue: String(format: "%.2f", vm.prices.map(\.price).min() ?? 0))
                    StockDetailInfo(detailTitle: "Market Cap", detailValue: "-")
                }
                .padding(.horizontal, 10)

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem{
                    Button{
                        dismiss()
                    }label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
            }

        }
        
            }
}


#Preview {
    StockDetailSheet(
        tickerSymbol: "AAPL",
        color: .blue,
        icon: "applelogo"
    )
}
