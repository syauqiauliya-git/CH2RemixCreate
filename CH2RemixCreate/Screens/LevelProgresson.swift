// LevelProgressionMap.swift
import SwiftUI

struct LevelProgressionMap: View {
    // 1. Relocate the local view state here
    @State private var currentLevel: Int = 0
    
    // 2. Transfer the localized rendering utilities
    private func directionColor(_ start: CGPoint, _ end: CGPoint) -> Color {
        end.y < start.y ? .green : .red
    }
    
    private func segmentColor(_ start: CGPoint, _ end: CGPoint, threshold: Int) -> Color {
        currentLevel >= threshold ? directionColor(start, end) : .gray
    }
    
    private func circleStrokeColor(threshold: Int, incomingStart: CGPoint, incomingEnd: CGPoint) -> Color {
        currentLevel >= threshold ? directionColor(incomingStart, incomingEnd) : .gray
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 16) {
                    Text("Level: \(currentLevel)")
                        .font(.headline)
                    Button("Increment") { currentLevel += 1 }
                        .buttonStyle(.borderedProminent)
                    Button("Reset") { currentLevel = 0 }
                        .buttonStyle(.bordered)
                }
                .padding(.horizontal)
                
                GeometryReader { proxy in
                    let visibleWidth = proxy.size.width
                    let contentWidth = proxy.size.width * 2
                    let contentHeight = proxy.size.height
                    
                    // Invoking your previously refactored external data structure
                    let calculatedPoints = PointsCalculator.calculateCoordinates(
                        contentWidth: contentWidth,
                        contentHeight: contentHeight
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            
                            
                            ForEach(1..<calculatedPoints.count-1, id: \.self) { index in
                                let startNode = calculatedPoints[index - 1]
                                let endNode = calculatedPoints[index]
                                
                                
                                Path { path in
                                    path.move(to: startNode)
                                    path.addLine(to: endNode)
                                }
                                .stroke(segmentColor(startNode, endNode, threshold: index), lineWidth: 10)
                                
                            }
                            
                            ForEach(1..<calculatedPoints.count, id: \.self){ index in
                                let startNode = calculatedPoints[index - 1]
                                let endNode = calculatedPoints[index]
                                let isHalf = (index % 2 == 1)
                                
                                Circle()
                                    .fill(Color.white)
                                    .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                    .frame(width: isHalf ? 35 : 50, height: isHalf ? 35 : 50)
                                    .position(calculatedPoints[index])
                            }
                            
                            Image("curved-text")
                                .position(calculatedPoints[11])
                            
                            NavigationLink(destination: QuizScreen()) {
                                Image("Planet1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .position(calculatedPoints[11])
                            }
                            
                        }
                        .frame(width: contentWidth, height: contentHeight + 200, alignment: .topLeading)
                    }
                    .frame(width: visibleWidth, height: contentHeight + 200)
                }
                .frame(height: 500)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("Background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    LevelProgressionMap()
}
