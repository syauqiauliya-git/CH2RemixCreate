//
//  stockSummary.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 27/04/26.
//

import SwiftUI

struct stockSummary: Identifiable{
    let id = UUID()
    let symbol: String
    let name: String
    let price: Double
    let prices: [Double]
    let color: Color
}
