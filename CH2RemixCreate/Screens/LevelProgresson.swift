// LevelProgressionMap.swift
import SwiftUI



struct LevelProgressionMap: View {
    @State private var quizzes: [Quiz] = mockQuizzes
    @State private var lessons: [Lesson] = mockLesson
    @State private var showLockedPopup = false
    @State var testMode: Bool
    @Binding var isGraduated: Bool
    @Binding var selectedTab: Int
    
    @State private var tapCount = 0
    
    
    private var currentLevel: Int {
        var highest = 0
        for (i, quiz) in quizzes.enumerated() {
            if quiz.isPassed { highest = i + 1 }
        }
        return highest
    }
    
    private var allCompleted: Bool {
        lessons.allSatisfy { $0.isPassed } && quizzes.allSatisfy { $0.isPassed }
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
    
    private func lessonNode(index: Int, startNode: CGPoint, endNode: CGPoint, points: [CGPoint]) -> some View {
        let lessonIndex = (index - 1) / 2
        let fill = isUnlocked(levelIndex: index) && !isReached(levelIndex: index)
        ? Color(hex: "C9F55F")
        : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode)
        let stroke = circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode)
        let circle = NodeCircle(size: 35, fillColor: fill, strokeColor: stroke)
        
        return Group {
            if isUnlocked(levelIndex: index), lessonIndex < lessons.count {
                NavigationLink(destination: LessonScreen(currentLesson: $lessons[lessonIndex])) { circle }
                    .buttonStyle(.plain)
            } else {
                Button { triggerLockedPopup() } label: { circle }
            }
        }
        .offset(x: points[index].x - 17.5, y: points[index].y - 17.5)
    }
    
    private func quizNode(index: Int, startNode: CGPoint, endNode: CGPoint, points: [CGPoint]) -> some View {
        let quizIndex = (index / 2) - 1
        let fill = isUnlocked(levelIndex: index) && !isReached(levelIndex: index)
        ? Color(hex: "C9F55F")
        : circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode)
        let stroke = circleStrokeColor(threshold: index, incomingStart: startNode, incomingEnd: endNode)
        let circle = NodeCircle(size: 50, fillColor: fill, strokeColor: stroke)
        
        return Group {
            if isUnlocked(levelIndex: index), quizIndex >= 0, quizIndex < quizzes.count {
                NavigationLink(destination: QuizScreen(quiz: $quizzes[quizIndex])) { circle }
                    .buttonStyle(.plain)
            } else {
                Button { triggerLockedPopup() } label: { circle }
            }
        }
        .offset(x: points[index].x - 25, y: points[index].y - 25)
    }
    
    private func triggerLockedPopup() {
        showLockedPopup = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            withAnimation { showLockedPopup = false }
        }
    }
    
    
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    
                    Text("Study Time!")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "E1DDCE"))
                        .padding(.bottom, 60)
                        .onTapGesture {
                            tapCount += 1
                            
                            if tapCount == 3{
                                for index in quizzes.indices { quizzes[index].isPassed = true }
                                for index in lessons.indices { lessons[index].isPassed = true }
                            }
                            
                            if tapCount == 5 {
                                for index in quizzes.indices { quizzes[index].isPassed = false }
                                for index in lessons.indices { lessons[index].isPassed = false }
                                tapCount = 0
                            }
                        }
                    
                    if (testMode) {
                        HStack(spacing: 16) {
                            Text("Level: \(currentLevel)")
                                .font(.headline)
                                .fontDesign(.rounded)
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
                        
                    }
                    
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

                                customAlienView()
                                    .offset(x: calculatedPoints[5].x - 25, y: calculatedPoints[4].y + 100)
                                
                                customAlienView()
                                    .offset(x: calculatedPoints[10].x - 25, y: calculatedPoints[6].y - 50)
                                
                                
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
                                    
                                    if index % 2 == 1 {
                                        lessonNode(index: index, startNode: startNode, endNode: endNode, points: calculatedPoints)
                                    } else {
                                        quizNode(index: index, startNode: startNode, endNode: endNode, points: calculatedPoints)
                                    }
                                }
                                
                                let planet = Image("Planet1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                                
                                Group {
                                    if isGraduated {
                                        Button {
                                            selectedTab = 1 // 👈 pindah ke tab Stocks
                                        } label: {
                                            planet
                                        }
                                        .buttonStyle(.plain)
                                        
                                    } else {
                                        ZStack{
                                            planet
                                                .opacity(0.5)
                                            Image(systemName: "lock.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(.white)
                                        }
                                        
                                    }
                                }
                                .offset(x: calculatedPoints[11].x - 100, y: calculatedPoints[11].y - 100)
                                
                                if (allCompleted) {
                                    Image("JumpIn")
                                        .offset(x: calculatedPoints[11].x - 100, y: calculatedPoints[11].y-150)
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
            .onChange(of: allCompleted) { _, completed in
                isGraduated = completed
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
                    .fontDesign(.rounded)
            }
        }
    }
}

// MARK: - Subviews

struct NodeCircle: View {
    let size: CGFloat
    let fillColor: Color
    let strokeColor: Color
    
    var body: some View {
        Circle()
            .fill(fillColor)
            .overlay(Circle().stroke(strokeColor, lineWidth: 2))
            .frame(width: size, height: size)
    }
}

struct customAlienView: View {
    let imageName: String = "alien"
    let size: Int = 60
    
    var body: some View {
        ZStack {
            Image("alien")
                .resizable()
                .scaledToFit()
            Color(hex: "393B55").opacity(0.9)
                .mask(
                    Image("alien")
                        .resizable()
                        .scaledToFit()
                )
        }
        .frame(width: 60, height: 60)
    }
}

#Preview ("Testing") {
    LevelProgressionMap(testMode: true, isGraduated: .constant(true), selectedTab: .constant(0))
}

#Preview ("Not Testing") {
    LevelProgressionMap(testMode: false, isGraduated: .constant(true), selectedTab: .constant(0))
}

//rsthtsrhsrhrh
//wait
