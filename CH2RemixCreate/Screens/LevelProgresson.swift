// LevelProgressionMap.swift
import SwiftUI



struct LevelProgressionMap: View {
    @State private var quizzes: [Quiz] = mockQuizzes
    @State private var lessons: [Lesson] = mockLesson
    @State private var showLockedPopup = false
    @Binding var isGraduated: Bool

    
    
    private var currentLevel: Int {
        var highest = 0
        for (i, quiz) in quizzes.enumerated() {
            if quiz.isPassed { highest = i + 1 }
        }
        return highest
    }
    
    
    private func directionColor(start: CGPoint, end: CGPoint) -> Color {
        Color(hex: "7C5CBF")
    }
    
    private func isReached(levelIndex: Int) -> Bool {
        let isLessonPoint = (levelIndex % 2 == 1)
        
        if isLessonPoint {
            let lessonIndex = (levelIndex - 1) / 2
            return lessonIndex < lessons.count && lessons[lessonIndex].isPassed
        } else {
            let quizIndex = (levelIndex / 2) - 1
            return quizIndex < quizzes.count && quizzes[quizIndex].isPassed
        }
    }
    
    private func segmentColor(start: CGPoint, end: CGPoint, threshold: Int) -> Color {
        isUnlocked(levelIndex: threshold) ? directionColor(start: start, end: end) : Color(hex: "2D2F4A")
    }
    
    private func circleStrokeColor(threshold: Int, incomingStart: CGPoint, incomingEnd: CGPoint) -> Color {
        if isReached(levelIndex: threshold) { return Color(hex: "7C5CBF") }
        if isUnlocked(levelIndex: threshold) { return Color(hex: "C9F55F") }
        return Color(hex: "2D2F4A")
    }
    
    private func isUnlocked(levelIndex: Int) -> Bool {
        if levelIndex <= 1 {
            return true
        }
        return isReached(levelIndex: levelIndex - 1)
    }
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    HStack(spacing: 16) {
                        Text("Level: \(currentLevel)")
                            .font(.headline)
                        Button("Increment") {
                            // find first unpassed node in sequence: lesson0, quiz0, lesson1, quiz1...
                            let totalSteps = lessons.count + quizzes.count
                            for step in 0..<totalSteps {
                                if step % 2 == 0 {
                                    let lessonIndex = step / 2
                                    if !lessons[lessonIndex].isPassed {
                                        lessons[lessonIndex].isPassed = true
                                        return
                                    }
                                } else {
                                    let quizIndex = step / 2
                                    if !quizzes[quizIndex].isPassed {
                                        quizzes[quizIndex].isPassed = true
                                        return
                                    }
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)

                        Button("Reset") {
                            for index in quizzes.indices { quizzes[index].isPassed = false }
                            for index in lessons.indices { lessons[index].isPassed = false }
                        }
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
                                    .stroke(segmentColor(start: startNode, end: endNode, threshold: index), lineWidth: 10)
                                    
                                }
                                
                                ForEach(1..<calculatedPoints.count, id: \.self) { index in
                                    
                                    let startNode = calculatedPoints[index - 1]
                                    let endNode = calculatedPoints[index]
                                    
                                    let isHalf = (index % 2 == 1)
                                    
                                    if isHalf {
                                        // --- LESSON NODES ---
                                        
                                        let lessonIndex = (index - 1) / 2
                                        
                                        if isUnlocked(levelIndex: index){
                                            if lessonIndex >= 0 && lessonIndex < lessons.count {
                                                NavigationLink(destination: LessonScreen (
                                                    currentLesson: $lessons[lessonIndex]
                                                )) {
                                                    Circle()
                                                        .fill(isUnlocked(levelIndex: index) && !isReached(levelIndex: index) ? Color(hex: "FFDE63") : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode))
                                                        .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                                        .frame(width: 35, height: 35)
                                                }
                                                .buttonStyle(.plain)
                                                .offset(x: calculatedPoints[index].x - 17.5, y: calculatedPoints[index].y - 17.5)
                                            }
                                            
                                        } else {
                                            
                                            Button(action: {
                                                showLockedPopup = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                                    withAnimation {
                                                        showLockedPopup = false
                                                    }
                                                }
                                                
                                            }) {
                                                Circle()
                                                    .fill(isUnlocked(levelIndex: index) && !isReached(levelIndex: index) ? Color(hex: "FFDE63") : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode))
                                                    .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                                    .frame(width: 35, height: 35)
                                                
                                            }
                                            .offset(x: calculatedPoints[index].x - 17.5, y: calculatedPoints[index].y - 17.5)
                                        }
                                        
                                    } else {
                                        
                                        // --- QUIZ NODES ---
                                        
                                        let quizIndex = (index / 2) - 1
                                        
                                        if isUnlocked(levelIndex: index){
                                            if quizIndex >= 0 && quizIndex < mockQuizzes.count {
                                                NavigationLink(destination: QuizScreen(
                                                    quiz: $quizzes[quizIndex]
                                                )) {
                                                    Circle()
                                                        .fill(isUnlocked(levelIndex: index) && !isReached(levelIndex: index) ? Color(hex: "FFDE63") : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode))
                                                        .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                                        .frame(width: 50, height: 50)
                                                }
                                                .buttonStyle(.plain)
                                                .offset(x: calculatedPoints[index].x - 25, y: calculatedPoints[index].y - 25)
                                            }
                                        } else {
                                            
                                            Button (action: {
                                                showLockedPopup = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                                    withAnimation {
                                                        showLockedPopup = false
                                                    }
                                                }
                                                
                                            }) {
                                                Circle()
                                                    .fill(isUnlocked(levelIndex: index) && !isReached(levelIndex: index) ? Color(hex: "FFDE63") : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode))
                                                    .overlay(Circle().stroke(circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode), lineWidth: 2))
                                                    .frame(width: 50, height: 50)
                                            }
                                            .offset(x: calculatedPoints[index].x - 25, y: calculatedPoints[index].y - 25)
                                        }
                                        
                                    }
                                }
                                
                                Image("Planet1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                    .offset(x: calculatedPoints[11].x - 100, y: calculatedPoints[11].y - 100)
                                
                                Image("JumpIn")
                                    .offset(x: calculatedPoints[11].x - 100, y: calculatedPoints[11].y-150)
                                
                                
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
            
            // Locked Popup
            if showLockedPopup {
                Text("Locked Level")
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .transition(.opacity) // Smooth transition
                    .zIndex(1) // Ensure it's on top
            }
        }
    }
}

#Preview {
    LevelProgressionMap(isGraduated: .constant(false))
}


//rsthtsrhsrhrh
//wait
