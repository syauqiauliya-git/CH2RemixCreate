import SwiftUI

// MARK: - Model
struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let icon: String
    let color: Color
    let prices: [PriceData]
}




// MARK: - Screen
struct StockListScreen: View {
    @State private var selectedStock: Stock?
    var stocks: [Stock]
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("Background")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(stocks) { stock in
                            StockCard(stock: stock)
                                .onTapGesture {
                                    selectedStock = stock
                                }
                        }
                    }
                    .padding()
                }
                .toolbar {
                    MyToolbar()
                }
                .sheet(item: $selectedStock) {stock in StockDetailSheet(stock: stock)
                }
            }
        }
    }
}

#Preview {
    let stocks: [Stock] = [

        Stock(symbol: "WBD", name: "Warner Bros", price: 12.34, icon: "film.fill", color: .blue, prices: [
            PriceData(date: makeDate(1), price: 8),
            PriceData(date: makeDate(2), price: 15),
            PriceData(date: makeDate(3), price: 7),
            PriceData(date: makeDate(4), price: 16),
            PriceData(date: makeDate(5), price: 12.34),
        ]),

        Stock(symbol: "NFLX", name: "Netflix", price: 450.21, icon: "tv.fill", color: .red, prices: [
            PriceData(date: makeDate(1), price: 380),
            PriceData(date: makeDate(2), price: 520),
            PriceData(date: makeDate(3), price: 360),
            PriceData(date: makeDate(4), price: 550),
            PriceData(date: makeDate(5), price: 450),
        ]),

        Stock(symbol: "HAS", name: "Hasbro", price: 65.10, icon: "gamecontroller.fill", color: .purple, prices: [
            PriceData(date: makeDate(1), price: 50),
            PriceData(date: makeDate(2), price: 80),
            PriceData(date: makeDate(3), price: 48),
            PriceData(date: makeDate(4), price: 85),
            PriceData(date: makeDate(5), price: 65),
        ]),

        Stock(symbol: "MAT", name: "Mattel", price: 22.45, icon: "doll.fill", color: .pink, prices: [
            PriceData(date: makeDate(1), price: 15),
            PriceData(date: makeDate(2), price: 30),
            PriceData(date: makeDate(3), price: 14),
            PriceData(date: makeDate(4), price: 32),
            PriceData(date: makeDate(5), price: 22.45),
        ]),

        Stock(symbol: "NTDOY", name: "Nintendo", price: 13.20, icon: "gamecontroller", color: .red, prices: [
            PriceData(date: makeDate(1), price: 9),
            PriceData(date: makeDate(2), price: 17),
            PriceData(date: makeDate(3), price: 8),
            PriceData(date: makeDate(4), price: 18),
            PriceData(date: makeDate(5), price: 13.2),
        ]),

        Stock(symbol: "RBLX", name: "Roblox", price: 40.55, icon: "cube.fill", color: .blue, prices: [
            PriceData(date: makeDate(1), price: 30),
            PriceData(date: makeDate(2), price: 55),
            PriceData(date: makeDate(3), price: 28),
            PriceData(date: makeDate(4), price: 60),
            PriceData(date: makeDate(5), price: 40.55),
        ]),

        Stock(symbol: "AAPL", name: "Apple", price: 175.30, icon: "applelogo", color: .green, prices: [
            PriceData(date: makeDate(1), price: 140),
            PriceData(date: makeDate(2), price: 200),
            PriceData(date: makeDate(3), price: 130),
            PriceData(date: makeDate(4), price: 210),
            PriceData(date: makeDate(5), price: 175.3),
        ]),

        Stock(symbol: "SONY", name: "Sony PlayStation", price: 90.12, icon: "playstation.logo", color: .indigo, prices: [
            PriceData(date: makeDate(1), price: 70),
            PriceData(date: makeDate(2), price: 110),
            PriceData(date: makeDate(3), price: 65),
            PriceData(date: makeDate(4), price: 115),
            PriceData(date: makeDate(5), price: 90),
        ]),

        Stock(symbol: "MCD", name: "McDonald's", price: 280.50, icon: "fork.knife", color: .yellow, prices: [
            PriceData(date: makeDate(1), price: 240),
            PriceData(date: makeDate(2), price: 310),
            PriceData(date: makeDate(3), price: 230),
            PriceData(date: makeDate(4), price: 320),
            PriceData(date: makeDate(5), price: 280),
        ]),

        Stock(symbol: "DIS", name: "Disney", price: 100.75, icon: "sparkles", color: .blue, prices: [
            PriceData(date: makeDate(1), price: 80),
            PriceData(date: makeDate(2), price: 130),
            PriceData(date: makeDate(3), price: 75),
            PriceData(date: makeDate(4), price: 140),
            PriceData(date: makeDate(5), price: 100.75),
        ]),

        // Indo (extra brutal 😈)

        Stock(symbol: "GOTO", name: "GoTo", price: 85, icon: "car.fill", color: .green, prices: [
            PriceData(date: makeDate(1), price: 50),
            PriceData(date: makeDate(2), price: 120),
            PriceData(date: makeDate(3), price: 40),
            PriceData(date: makeDate(4), price: 140),
            PriceData(date: makeDate(5), price: 85),
        ]),

        Stock(symbol: "ICBP", name: "Indofood", price: 1020, icon: "fork.knife", color: .orange, prices: [
            PriceData(date: makeDate(1), price: 850),
            PriceData(date: makeDate(2), price: 1150),
            PriceData(date: makeDate(3), price: 800),
            PriceData(date: makeDate(4), price: 1200),
            PriceData(date: makeDate(5), price: 1020),
        ])
    ]

    StockListScreen(stocks: stocks)
}

// MARK: - Card
struct StockCard: View {
    var stock: Stock
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            RoundedRectangle(cornerRadius: 16)
                .fill(stock.color.gradient)
            
            VStack(alignment: .leading) {
                
                HStack {
                    Text(stock.symbol)
                    Spacer()
                    Text("\(stock.price, specifier: "%.2f")")
                }
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(.top, 10)
                
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                ChartView(stockPrices: stock.prices, width: 150, height: 100)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Image(systemName: stock.icon)
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .padding(12)
        }
        .frame(height: 238)
        .shadow(radius: 5)
    }
}
