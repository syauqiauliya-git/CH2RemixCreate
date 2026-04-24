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


