//
//  Congratulations.swift
//  CH2RemixCreate
//

import SwiftUI

struct Congratulations: View {
    let score: Int
    
    @State private var pathScore1: CGFloat = 0
    @State private var pathScore2: CGFloat = 0
    @State private var pathScore3: CGFloat = 0
    @State private var pathScore4: CGFloat = 0
    
    @State private var circle1Scale: CGFloat = 0
    @State private var circle2Scale: CGFloat = 0
    
    private let segDuration: Double = 0.5
    private let darkGray = Color(white: 0.3)
    
    @Environment(\.dismiss) var dismiss
        
    var body: some View {
        VStack {
            
            // --- HEADER ---
            Text("Your Results")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.secondary)
                .padding(.top, 40)
                .padding(.bottom, 175)
                .fontDesign(.rounded)
            
            // --- CHART AREA ---
            GeometryReader { proxy in
                let w = proxy.size.width
                let h = proxy.size.height
                
                let finalY = h * 0.35
                
                // Hardcoded points
                let p0 = CGPoint(x: 0, y: h)
                let p1 = CGPoint(x: w * 0.25, y: h - 69)
                let p2 = CGPoint(x: w * 0.5, y: h * -0.1)
                let p3 = CGPoint(x: w * 0.75, y: h * 1)
                let p4 = CGPoint(x: w, y: finalY)
                
                ZStack {
                    
                    // --- PERMANENT BACKGROUND TRACK ---
                    ZStack {
                        Path { path in
                            path.move(to: p0)
                            path.addLine(to: p1)
                            path.addLine(to: p2)
                            path.addLine(to: p3)
                            path.addLine(to: p4)
                        }
                        .stroke(darkGray, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        
                        Circle().frame(width: 20, height: 20).position(p2).foregroundStyle(darkGray)
                        Circle().frame(width: 20, height: 20).position(p3).foregroundStyle(darkGray)
                    }
                    
                    // --- ACHIEVED COLORED TRACK ---
                    if score == 1 {
                        Path { path in
                            path.move(to: p0)
                            path.addLine(to: p1)
                        }
                        .trim(from: 0, to: pathScore1)
                        .stroke(Color(hex: "7C5CBF"), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    }
                    
                    if score >= 2 {
                        Path { path in
                            path.move(to: p0)
                            path.addLine(to: p1)
                            path.addLine(to: p2)
                        }
                        .trim(from: 0, to: pathScore2)
                        .stroke(Color(hex: "7C5CBF"), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    }
                    
                    if score >= 3 {
                        Path { path in
                            path.move(to: p2)
                            path.addLine(to: p3)
                        }
                        .trim(from: 0, to: pathScore3)
                        .stroke(Color(hex: "C9F55F"), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .position(p2)
                            .foregroundStyle(Color(hex: "C9F55F"))
                            .scaleEffect(circle1Scale)
                    }
                    
                    if score == 4 {
                        Path { path in
                            path.move(to: p3)
                            path.addLine(to: p4)
                        }
                        .trim(from: 0, to: pathScore4)
                        .stroke(Color(hex: "7C5CBF"), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                        
                        Circle()
                            .frame(width: 20, height: 20)
                            .position(p3)
                            .foregroundStyle(Color(hex: "7C5CBF"))
                            .scaleEffect(circle2Scale)
                    }

                }
            }
            .frame(height: 125)
            .padding(.horizontal)
            .padding(.bottom, 40)
            
            // --- SCORE
            VStack(spacing: 8) {
                Text("\(score)/4")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundStyle(.primary)
                    .fontDesign(.rounded)
                
                Text(score == 4 ? "Perfect!" : (score == 3 ? "Nice!" : "Keep Trying!"))
                    .font(.title3)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
                    .foregroundStyle(score > 3 ? .green : (score > 2 ? .orange : .red))
            }
            
            Spacer()
            
            // --- CALL TO ACTION ---
            Text("Press Anywhere to Continue")
                .font(.subheadline)
                .fontDesign(.rounded)
                .fontWeight(.medium)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 75)
                .onTapGesture {
                    dismiss()
                }
        }
        .onAppear {
            startSequence()
        }
        .toolbar(.hidden, for:.tabBar)
    }
    
    private func startSequence() {
        if score == 1 {
            withAnimation(.linear(duration: segDuration)) {
                pathScore1 = 1.0
            }
        }
        
        if score >= 2 {
            withAnimation(.linear(duration: segDuration * 2)) { // Extended duration for the combined segment
                pathScore2 = 1.0
            }
        }
        
        if score >= 3 {
            withAnimation(.linear(duration: segDuration).delay(segDuration * 2)) {
                pathScore3 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (segDuration * 2)) {
                circle1Scale = 1.0
            }
        }
        
        if score == 4 {
            withAnimation(.linear(duration: segDuration).delay(segDuration * 3)) {
                pathScore4 = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (segDuration * 3)) {
                circle2Scale = 1.0
            }
        }
    }
}

// Previews
#Preview("Score 0") { Congratulations(score: 0) }
#Preview("Score 1") { Congratulations(score: 1) }
#Preview("Score 2") { Congratulations(score: 2) }
#Preview("Score 3") { Congratulations(score: 3) }
#Preview("Score 4") { Congratulations(score: 4) }
