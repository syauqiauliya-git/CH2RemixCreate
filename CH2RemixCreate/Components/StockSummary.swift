//
//  StockSummary.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 22/04/26.
//
import SwiftUI

struct StockSummary: Identifiable{
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let prices: [Double]
}
