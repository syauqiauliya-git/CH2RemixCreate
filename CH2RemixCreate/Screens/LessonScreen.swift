//
//  LessonScreen.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 23/04/26.
//

import SwiftUI


struct LessonScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var currentLesson:Lesson
    
    var body: some View {
    
        
        //        let currentQuestion = quiz.questions[currentQuestionIndex]
        
        VStack {
//            Spacer()
            Spacer()
            ZStack(){
                Circle()
                    .fill(Color(hex: "C9F55F"))
                    .frame(width: 100)
                    .opacity(0.9)
                    
                    
                if let image = currentLesson.image{
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            
            Spacer()
            Text(currentLesson.title)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
       
            
           
            
     
            
            //card
            ZStack{
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.4))
                  
                    .stroke(Color.white).opacity(0.3)
                    
                
                
                VStack(spacing:10){
                    

                    
                Text(currentLesson.description)
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(7)
                    .padding(.horizontal)
                }
            }
            .frame(height: 200)
            .padding(20)
            
            Spacer()
            
            
            Spacer()
            
            Button(action: {
                 currentLesson.isPassed = true
                print("Hello")
                dismiss()
            }) {
                HStack{
                    Text("Finish")
                        .bold()
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .bold))
                }
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "C9F55F").opacity(0.75))
                .foregroundColor(.white)
                .cornerRadius(20)
                .glassEffect()
            }
            .padding(.bottom, 10)
            .padding(.horizontal)
            
            

            
        }
        .background(Color(hex: "393B55"))
        
    }
}
        
#Preview {
    let lesson = Lesson(
        title: "What is a Stock?",
        description: "A stock is like owning a tiny piece of a company! If the company does well, your tiny piece becomes more valuable. It’s like sharing a pizza with friends, but instead of pizza, you share a company!",
        image: Image(systemName: "building.2.fill")
    )
    LessonScreen(currentLesson: .constant(lesson))
}
