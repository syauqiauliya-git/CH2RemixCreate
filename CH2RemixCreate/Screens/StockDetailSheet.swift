//
//  StockDetailSheetScreen.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 21/04/26.
//

import SwiftUI


struct StockDetailSheet: View {
    let stock: Stock
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack{
            
            VStack(alignment: .leading){
                HStack(alignment: .center){
                    Image(systemName: stock.icon)
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                        .padding(12)
                    VStack (alignment: .leading){
                        Text(stock.symbol)
                            .font(.system(size: 50))
                        Text(stock.name)
                            .foregroundStyle(.gray)
                    }
                    .bold()
                    
                }
                .frame(maxWidth: .infinity)
                
                HStack{
                    Text("\(stock.price, specifier: "%.2f")")
                        .font(.system(size: 35))
                    Text("2.75%")
                        .foregroundStyle(.green)
                    
                }
                .bold()
                Text("Daily")
                //            Text("CHART")
                ChartView(stockPrices: stock.prices, width: .infinity, height: 300)
                Spacer()
                HStack{
                    StockDetailInfo()
                    StockDetailInfo()
                }
                .padding(.horizontal, 10)
                HStack{
                    StockDetailInfo()
                    StockDetailInfo()
                }
                .padding(.horizontal, 10)
                Spacer()
                Spacer()
                
                
                //Nanti ini bikin struct aja karna repeatable
                
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
    
    
    let stocks1 = Stock(symbol: "GOTO", name: "GoJek Tokopedia", price: 85, icon: "car.fill", color: .green, prices: [
        PriceData(date: makeDate(1), price: 80),
        PriceData(date: makeDate(2), price: 40),
        PriceData(date: makeDate(3), price: 78),
        PriceData(date: makeDate(4), price: 84),
        PriceData(date: makeDate(5), price: 85),
    ])
        
    StockDetailSheet(stock: stocks1)
}


struct StockDetailInfo:View {
    var body: some View {
        var detailTitle: String = "High"
        var detailValue: String = "80"
        HStack{
//            Spacer()
            Text(detailTitle)
                .foregroundStyle(.gray)
            Spacer()
            Text(detailValue)
                .font(.largeTitle)
        }
        .bold()
        .padding(10)
        .frame(maxWidth: 150)
    }
}


