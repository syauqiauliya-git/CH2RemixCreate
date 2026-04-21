//
//  QuizPage.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 20/04/26.
//
import SwiftUI

struct Question{
    let question: String
    let answers: [String]
    let correctAnswer: String
}


struct QuizScreen: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String? = nil
    var body: some View {
        
        VStack {
            Text("Answer!")
                .font(.title.bold())

            Spacer()

            //card
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(.gray.opacity(0.5))
                VStack(spacing:12){
                    Text("Image")
                    Text("Question")
                }
            }
            .frame(height: 400)

            Spacer()

//            Text("Dots")
            HStack(spacing: 8) {
                Circle().frame(width: 8, height: 8)
                Circle().frame(width: 8, height: 8).opacity(0.3)
                Circle().frame(width: 8, height: 8).opacity(0.3)
            }

            Spacer()

//            Text("Answers")
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            LazyVGrid(columns: columns, spacing: 16){
                ForEach(0..<4){ _ in
                    Text("Answer")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    QuizScreen()
}
