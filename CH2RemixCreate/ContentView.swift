//
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI


struct ContentView: View {
    
    @State var currentLevel: Int = 0
    var numOfLevels: Int = PointsCalculator.points.count
    
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
                    Button("Increment") { currentLevel += 1 }
                    Button("Reset") { currentLevel = 0 }
                    
                }
                .padding(.horizontal)
                
                GeometryReader { proxy in
                    let visibleWidth = proxy.size.width
                    let contentWidth = proxy.size.width * 2
                    let contentHeight = proxy.size.height
                    
                    let calculatedPoints = PointsCalculator.calculateCoordinates(contentWidth: contentWidth, contentHeight: contentHeight)
                    
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
    ContentView()
}

