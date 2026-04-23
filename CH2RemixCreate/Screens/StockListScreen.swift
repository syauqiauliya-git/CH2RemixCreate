import SwiftUI
import Charts
import Combine

struct stockSummary: Identifiable{
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let prices: [Double]
    let color: Color
}

@MainActor
class StockListVM: ObservableObject {
    @Published var summaries: [StockSummary] = []
    
    func fetchAll() async {
        let symbols = ["RBLX", "NFLX", "WBD", "AAPL", "TSLA"]
        
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

struct StockListScreen: View {
    @State private var selectedStock: String? = nil
    @State private var showSheet = false
    let stocks: [String]
    let icon: [String]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var color: Color = Color.black

    var body: some View {
        NavigationStack{
            ZStack{
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(Array(stocks.enumerated()), id: \.element) { index, symbol in
                            StockCardContainer(
                                symbol: symbol,
                                color: cardColors[index % cardColors.count],
                                icon: icon[index % icon.count]
                            )
                            .onTapGesture {
                                selectedStock = symbol
                                showSheet = true
                            }
                        }
                    }
                    .padding()
                }
            }
            .toolbar {
                MyToolbar()
            }
            .sheet(isPresented: $showSheet){
                if let stock = selectedStock {
                        StockDetailSheet(tickerSymbol: stock,
                                         color: cardColors[stocks.firstIndex(of: stock) ?? 0 % cardColors.count],
                                         icon: icon[stocks.firstIndex(of: stock) ?? 0 % icon.count])
                        .presentationBackground(.clear)
//                        .presentationBackground(.gray)
                    }
            }
        }
    }
}
        

#Preview {
    let cardIcons: [String] = [
        "gamecontroller.fill",
        "tv.fill",
        "building.2.fill",
        "applelogo",
        "car.fill"
    ]
    
    


    StockListScreen(stocks: ["RBLX", "NFLX", "WBD", "AAPL", "TSLA"], icon: ["gamecontroller.fill",
                                                                            "tv.fill",
                                                                            "building.2.fill",
                                                                            "applelogo",
                                                                            "car.fill"])
}

let cardColors: [Color] = [
    Color.blue, // blue
//    Color.brown, // brown/orange
    Color.purple, // purple
    Color.orange, // red
    Color.black,
//    Color.gray,// dark,
    Color.yellow
]

struct StockCard: View {
    var stock: StockSummary
    var color: Color = .gray
    var icon: String
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            RoundedRectangle(cornerRadius: 16)
//                .fill(.gray)
            
//                .fill(.clear)
//                .stroke(.white, lineWidth: 1)
            
//                .fill(cardColors.randomElement() ?? .gray)
                .fill(color)
                .fill(.ultraThinMaterial)
                .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(0.3), lineWidth: 1)
                    )
            VStack(alignment: .leading, ) {
                
                HStack {
                    Text(stock.symbol)
                    Spacer()
                    Text("\(stock.price, specifier: "%.2f")")
                }
                .font(.title2.bold())
                .foregroundStyle(.white)
                
                Text(stock.name)
                    .font(.caption)
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
