//
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI

struct ContentView: View {
    
    @State var currentLevel: Int = 1

    // Directional color for segments: green if going up (end.y < start.y), red if going down
    private func directionColor(_ start: CGPoint, _ end: CGPoint) -> Color {
        end.y < start.y ? .green : .red
    }
    // Gate by threshold: gray until unlocked
    private func segmentColor(_ start: CGPoint, _ end: CGPoint, threshold: Int) -> Color {
        currentLevel >= threshold ? directionColor(start, end) : .gray
    }
    // Circle stroke color follows the incoming segment's color, or gray if locked
    private func circleStrokeColor(threshold: Int, incomingStart: CGPoint, incomingEnd: CGPoint) -> Color {
        currentLevel >= threshold ? directionColor(incomingStart, incomingEnd) : .gray
    }

    var body: some View {
        
        ZStack{
            Image("Background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    Text("Level: \(currentLevel)")
                    Button("Increment") { currentLevel += 1 }
                    Button("Reset") { currentLevel = 1 }

                }
                .padding(.horizontal)

                GeometryReader { proxy in
                    let visibleWidth = proxy.size.width
                    let contentWidth = proxy.size.width * 2
                    let contentHeight = proxy.size.height

                    // Points laid out across the scrollable content width/height
                    let point1: CGPoint = .init(x: -10, y: contentHeight)
                    let point1half: CGPoint = .init(x: contentWidth * 0.5 / 12, y: contentHeight * 0.675)
                    let point2 = CGPoint(x: contentWidth * 1 / 12, y: contentHeight * 0.4)
                    let point2half = CGPoint(x: contentWidth * 2.5 / 12, y: contentHeight * 0.525)
                    let point3: CGPoint = .init(x: contentWidth * 4 / 12, y: contentHeight * 0.65)
                    let point3half = CGPoint(x: contentWidth * 4.9 / 12, y: contentHeight * 0.4)
                    let point4: CGPoint = .init(x: contentWidth * 6 / 12, y: contentHeight * 0.1)
                    let point5: CGPoint = .init(x: contentWidth * 8 / 12, y: contentHeight * 0.3)
                    let point6: CGPoint = .init(x: contentWidth * 10 / 12, y: contentHeight * 0.7)
                    let point7: CGPoint = .init(x: contentWidth, y: contentHeight * 0.5)

                    // Thresholds for each segment (adjust as needed)
                    let t12 = 1
                    let t23 = 2
                    let t34 = 3
                    let t45 = 4
                    let t56 = 5
                    let t67 = 6

                    ScrollView(.horizontal, showsIndicators: false) {
                        ZStack {
                            // Segments
                            Path { path in
                                path.move(to: point1)
                                path.addLine(to: point2)
                            }
                            .stroke(segmentColor(point1, point2, threshold: t12), lineWidth: 10)

                            Path { path in
                                path.move(to: point2)
                                path.addLine(to: point3)
                            }
                            .stroke(segmentColor(point2, point3, threshold: t23), lineWidth: 10)

                            Path { path in
                                path.move(to: point3)
                                path.addLine(to: point4)
                            }
                            .stroke(segmentColor(point3, point4, threshold: t34), lineWidth: 10)

                            Path { path in
                                path.move(to: point4)
                                path.addLine(to: point5)
                            }
                            .stroke(segmentColor(point4, point5, threshold: t45), lineWidth: 10)

                            Path { path in
                                path.move(to: point5)
                                path.addLine(to: point6)
                            }
                            .stroke(segmentColor(point5, point6, threshold: t56), lineWidth: 10)

                            Path { path in
                                path.move(to: point6)
                                path.addLine(to: point7)
                            }
                            .stroke(segmentColor(point6, point7, threshold: t67), lineWidth: 10)

                            // Circles (white fill, stroke shows color when unlocked)
                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t12, incomingStart: point1, incomingEnd: point2), lineWidth: 2))
                                .frame(width: 35, height: 35)
                                .position(point1half)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t12, incomingStart: point1, incomingEnd: point2), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point2)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t23, incomingStart: point2, incomingEnd: point3), lineWidth: 2))
                                .frame(width: 35, height: 35)
                                .position(point2half)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t23, incomingStart: point2, incomingEnd: point3), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point3)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t34, incomingStart: point3, incomingEnd: point4), lineWidth: 2))
                                .frame(width: 35, height: 35)
                                .position(point3half)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t34, incomingStart: point3, incomingEnd: point4), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point4)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t45, incomingStart: point4, incomingEnd: point5), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point5)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t56, incomingStart: point5, incomingEnd: point6), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point6)

                            Circle()
                                .fill(Color.white)
                                .overlay(Circle().stroke(circleStrokeColor(threshold: t67, incomingStart: point6, incomingEnd: point7), lineWidth: 2))
                                .frame(width: 50, height: 50)
                                .position(point7)
                        }
                        .frame(width: contentWidth, height: contentHeight, alignment: .topLeading)
                    }
                    .frame(width: visibleWidth, height: contentHeight)
                }
                .frame(height: 450)
            }
            
        }
    }
}

#Preview {
    ContentView()
}
