// LevelProgressionMap.swift
import SwiftUI

struct LevelProgressionMap: View {
    @State private var currentLevel: Int = 0
    
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
                            
                            ForEach(1..<calculatedPoints.count, id: \.self) { index in
                                let startNode = calculatedPoints[index - 1]
                                let endNode = calculatedPoints[index]
                                
                                // isHalf is true for odd indices: 1, 3, 5, 7, 9, 11
                                let isHalf = (index % 2 == 1)
                                
                                if isHalf {
                                    // --- SMALL NODES (Static, Unclickable) ---
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                        .frame(width: 35, height: 35)
                                        .position(calculatedPoints[index])
                                    
                                } else {
                                    // --- LARGE NODES (Clickable Quiz Links) ---
                                    
                                    // Maps the even loop index (2, 4, 6, 8, 10) to the quiz array index (0, 1, 2, 3, 4)
                                    let quizIndex = (index / 2) - 1
                                    
                                    // Safety check to ensure we don't crash if the number of points exceeds the number of quizzes
                                    if quizIndex >= 0 && quizIndex < mockQuizzes.count {
                                        NavigationLink(destination: QuizScreen(
                                            isPassed: .constant(false),
                                            quizId: .constant(mockQuizzes[quizIndex].id),
                                            quiz: mockQuizzes[quizIndex]
                                        )) {
                                            Circle()
                                                .fill(Color.white)
                                                .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                                .frame(width: 50, height: 50)
                                                .position(calculatedPoints[index])
                                        }
                                    } else {
                                        // Fallback for any extra large nodes that don't have a matching quiz
                                        Circle()
                                            .fill(Color.white)
                                            .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                            .frame(width: 50, height: 50)
                                            .position(calculatedPoints[index])
                                    }
                                }
                            }
                            
                            Image("curved-text")
                                .position(calculatedPoints[11])
                            
                            
                            Image("Planet1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .position(calculatedPoints[11])
                            
                            
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
