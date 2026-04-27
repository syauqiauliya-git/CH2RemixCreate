//
//  StockDetailInfo.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//

import SwiftUI


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
        .fontDesign(.rounded)
    
        .padding(10)
        .frame(maxWidth: 170)
    }
}
