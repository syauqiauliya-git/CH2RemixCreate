import SwiftUI

// MARK: - Model
struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let name: String
    let price: String
    let icon: String
    let color: Color
}




// MARK: - Screen
struct StockListScreen: View {
    var stocks: [Stock]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(stocks) { stock in
                        StockCard(stock: stock)
                    }
                }
                .padding()
            }
            .toolbar {
                MyToolbar()
            }
        }
    }
}

#Preview {
    // MARK: - Sample Data
    let stocks: [Stock] = [
        Stock(symbol: "WBD", name: "Warner Bros", price: "12.34", icon: "film.fill", color: .blue),
        Stock(symbol: "NFLX", name: "Netflix", price: "450.21", icon: "tv.fill", color: .red),
        Stock(symbol: "HAS", name: "Hasbro", price: "65.10", icon: "gamecontroller.fill", color: .purple),
        Stock(symbol: "MAT", name: "Mattel", price: "22.45", icon: "doll.fill", color: .pink),
        Stock(symbol: "NTDOY", name: "Nintendo", price: "13.20", icon: "gamecontroller", color: .red),
        Stock(symbol: "RBLX", name: "Roblox", price: "40.55", icon: "cube.fill", color: .blue),
        Stock(symbol: "AAPL", name: "Apple", price: "175.30", icon: "applelogo", color: .green),
        Stock(symbol: "SONY", name: "Sony PlayStation", price: "90.12", icon: "playstation.logo", color: .indigo),
        Stock(symbol: "MCD", name: "McDonald's", price: "280.50", icon: "fork.knife", color: .yellow),
        Stock(symbol: "DIS", name: "Disney", price: "100.75", icon: "sparkles", color: .blue),
        Stock(symbol: "PARA", name: "Paramount", price: "14.88", icon: "star.fill", color: .purple),
        Stock(symbol: "DASH", name: "DoorDash", price: "75.60", icon: "bicycle", color: .red),
        Stock(symbol: "MSFT", name: "Microsoft", price: "330.90", icon: "square.grid.2x2.fill", color: .blue),
        Stock(symbol: "EA", name: "Electronic Arts", price: "130.44", icon: "gamecontroller.fill", color: .orange),
        Stock(symbol: "HSY", name: "Hershey", price: "210.22", icon: "gift.fill", color: .brown),
        Stock(symbol: "MDLZ", name: "Mondelez", price: "72.15", icon: "takeoutbag.and.cup.and.straw.fill", color: .orange),
        Stock(symbol: "PEP", name: "Pepsi", price: "180.10", icon: "drop.fill", color: .blue),
        Stock(symbol: "SBUX", name: "Starbucks", price: "95.33", icon: "cup.and.saucer.fill", color: .green),
        Stock(symbol: "NKE", name: "Nike", price: "110.77", icon: "figure.run", color: .black),
        Stock(symbol: "CROX", name: "Crocs", price: "98.66", icon: "shoe.fill", color: .green),
        
        // Indo stocks
        Stock(symbol: "CMRY", name: "Cimory", price: "1.250", icon: "carton.fill", color: .green),
        Stock(symbol: "AMRT", name: "Alfamart", price: "2.950", icon: "storefront.fill", color: .red),
        Stock(symbol: "GOTO", name: "GoTo", price: "85", icon: "car.fill", color: .green),
        Stock(symbol: "ICBP", name: "Indofood", price: "10.200", icon: "fork.knife", color: .orange),
        Stock(symbol: "MYOR", name: "Mayora", price: "2.400", icon: "cup.and.saucer.fill", color: .brown),
        Stock(symbol: "GOOD", name: "Garudafood", price: "480", icon: "takeoutbag.and.cup.and.straw.fill", color: .orange),
        Stock(symbol: "ULTJ", name: "Ultrajaya", price: "1.700", icon: "drop.fill", color: .blue),
        Stock(symbol: "CAMP", name: "Campina", price: "350", icon: "snowflake", color: .cyan),
        Stock(symbol: "UNVR", name: "Unilever", price: "4.500", icon: "sparkles", color: .blue)
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
                    Text(stock.price)
                }
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding(.top, 10)
                
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
                
                ChartView(width: 150, height: 100)
            }
            .padding(.horizontal, 16)
            
            Image(systemName: stock.icon)
                .font(.system(size: 40))
                .foregroundStyle(.white)
                .padding(12)
        }
        .frame(height: 200)
        .shadow(radius: 5)
    }
}
