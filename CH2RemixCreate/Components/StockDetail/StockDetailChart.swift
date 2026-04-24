//
//  StockDetailChart.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 24/04/26.
//

import SwiftUI
import Charts
import Combine
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
