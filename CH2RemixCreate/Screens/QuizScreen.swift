//
//  QuizPage.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 20/04/26.
//
import SwiftUI


struct QuizScreen: View {
    @Binding var quiz: Quiz
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    @State private var isAnswerLocked = false
    
    @State private var scoreCount: Int = 0
    @State private var isCongratulationsPresented: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        
        let currentQuestion = quiz.questions[currentQuestionIndex]
        
        VStack(alignment: .center) {
            
            Text("Answer!")
                .font(.title.bold())
                .fontDesign(.rounded)
            
            Spacer()
            
            ZStack(alignment: .top) {
                
                ZStack{
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3))
                        )
                        .frame(height: 400)
                        .padding(.top, 55)
                    
                    Text(currentQuestion.question)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .fontDesign(.rounded)
                        .bold()
                        .padding(.top, 55)
                }
                
                
               
                if let image = currentQuestion.questionImage {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "C9F55F"))
                            .frame(width: 120)
                        
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                    .offset(y: 0) // bisa di tweak (-10, dll)
                }
                
            
            }
        
            


                
                
//

            
            
            

            
            HStack(spacing: 8) {
                ForEach(0..<quiz.questions.count, id: \.self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .opacity(index == currentQuestionIndex ? 1.0 : 0.3)
                        .animation(.easeInOut, value: currentQuestionIndex)
                }
            }
            
            Spacer()
            
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(currentQuestion.answers, id: \.self) { answer in
                    Button(action: {
                        if isAnswerLocked {return}
                        isAnswerLocked = true
                        selectedAnswer = answer
                        if (selectedAnswer == currentQuestion.correctAnswer) {
                            scoreCount += 1
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if currentQuestionIndex + 1 < quiz.questions.count {
                                currentQuestionIndex += 1
                                selectedAnswer = nil
                                isAnswerLocked = false
                            } else {
                                if scoreCount > 2 {
                                    quiz.isPassed = true
                                }
                                isCongratulationsPresented = true
                            }
                        }
                    }) {
                        Text(answer)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding()
                            .frame(width: 180, height: 80)
                            .background(selectedAnswer != answer ? Color.gray.opacity(0.4): (selectedAnswer == currentQuestion.correctAnswer ? Color.green.opacity(0.3): Color.red.opacity(0.3)))
                            
                            .cornerRadius(12)
                        
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Spacer()
        }
        .toolbar(.hidden, for:.tabBar)

        
        .padding()
        .fullScreenCover(isPresented: $isCongratulationsPresented, onDismiss: {
            dismiss()
        }) {
            Congratulations(score: scoreCount)
        }
        .background(Color(hex: "393B55"))
            .ignoresSafeArea()
        
    }
        
        
    
}
   

#Preview {
    QuizScreen(quiz: .constant(mockQuizzes[0]))
}
