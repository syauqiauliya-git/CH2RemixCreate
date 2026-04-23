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
    
    var summary: StockSummary? {
        guard let latestPrice = prices.last?.price else { return nil }
        
        return StockSummary(
            symbol: tickerSymbol,
            name: companyName,
            price: latestPrice,
            prices: prices.map { $0.price },
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

struct StockDetailInfo:View {
    var detailTitle: String = "High"
    var detailValue: String = "80"
    var body: some View {
        
        HStack{
//            Spacer()
            Text(detailTitle)
                .foregroundStyle(.gray)
            Spacer()
            Text(detailValue)
                .font(.title)
        }
        .bold()
        .padding(10)
        .frame(maxWidth: 170)
    }
}

// MARK: - View
struct StockDetailChart: View {
    @ObservedObject var vm: StockVM

    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 12) {

            // Nama perusahaan / loading state
            if vm.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if let error = vm.errorMessage {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
            
            Picker("Chart Mode", selection: $vm.selectedMode) {
                ForEach(ChartMode.allCases.filter { $0 != .summary }) { mode in
                    Text(mode.rawValue)
                        .tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: vm.selectedMode) {
                Task {
                    await vm.fetch()
                }
            }

            // Chart
            if !vm.prices.isEmpty {
                Chart(vm.prices) { item in
                    
                    LineMark(
                        x: .value("Time", item.date),
                        y: .value("Price", item.price)
                    )
                    .foregroundStyle(.green)
                    
                    AreaMark(
                        x: .value("Time", item.date),
                        yStart: .value("Price", vm.prices.map(\.price).min() ?? 0),
                        yEnd: .value("Price", item.price)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.green.opacity(0.2),
                                Color.green.opacity(0.1),
                                .clear
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                }
                .frame(height: 250)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: vm.selectedMode.axisFormat)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing)
                }
                
                .chartYScale(domain: {
                    let prices = vm.prices.map { $0.price }
                    let min = prices.min() ?? 0
                    let max = prices.max() ?? 1

                    let padding = (max - min) * 0.05

                    return (min - padding)...(max + padding)
                }())
                
                
                            } else if !vm.isLoading {
                Text("Tidak ada data untuk ditampilkan.")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 250)
            }
        }
        
        .padding()
        .task {
            await vm.fetch()
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
