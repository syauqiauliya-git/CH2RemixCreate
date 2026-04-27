import SwiftUI
import Charts
import Combine






struct StockListScreen: View {
    @State private var searchText = ""
    @State private var selectedStock: String? = nil
    @State private var showSheet = false
    let stocks: [String] = stockListDummyData
    let icon: [String] = stockListDummyIcon
    
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
                        ForEach(
                            Array(stocks.filter {
                                searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
                            }.enumerated()),
                            id: \.element
                        ) { index, symbol in
                            let originalIndex = stocks.firstIndex(of: symbol) ?? 0

                            StockCardContainer(
                                symbol: symbol,
                                color: cardColors[originalIndex % cardColors.count],
                                icon: icon[originalIndex % icon.count]
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
        .searchable(text: $searchText, prompt: "Search stocks...")
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
    
    
    
    
    StockListScreen()
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


