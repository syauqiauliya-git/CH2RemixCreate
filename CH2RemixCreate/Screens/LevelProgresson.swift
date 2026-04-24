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
                    
                    // Invoking external data structure
                    let calculatedPoints = PointsCalculator.calculateCoordinates(
                        contentWidth: contentWidth,
                        contentHeight: contentHeight
                    )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack (alignment: .topLeading) {
                            
                            
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
                                
                                let isHalf = (index % 2 == 1)
                                
                                if isHalf {
                                    // --- SMALL NODES ---
                                    Circle()
                                        .fill(Color.white)
                                        .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                        .frame(width: 35, height: 35)
                                        .offset(x: calculatedPoints[index].x - 17.5, y: calculatedPoints[index].y - 17.5)
                                } else {

                                    let quizIndex = (index / 2) - 1
                                    
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
                                        }
                                        .buttonStyle(.plain)
                                        .offset(x: calculatedPoints[index].x - 25, y: calculatedPoints[index].y - 25)
                                    }
                                }
                            }
                            
                            Image("curved-text")
                                .offset(x: calculatedPoints[11].x, y: calculatedPoints[11].y)
                            
                            Image("Planet1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .offset(x: calculatedPoints[11].x - 100, y: calculatedPoints[11].y - 100)
                            
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
