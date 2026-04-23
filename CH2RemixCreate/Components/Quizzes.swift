//
//  Quizzes.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 23/04/26.
//


import SwiftUI

struct Quiz: Identifiable {
    let id: UUID
    let questions: [Question]
    let isPassed: Bool
}

struct Question{
    let question: String
    let answers: [String]
    let correctAnswer: String
    var questionImage: Image?
}

// MARK: - Mock Data
let mockQuestions: [Question] = [
    Question(
        question: "What is the primary function of a @State property wrapper?",
        answers: ["Network Requests", "Local View State", "Global Navigation", "Database Storage"],
        correctAnswer: "Local View State",
        questionImage: Image(systemName: "cube.box.fill")
    ),
    Question(
        question: "Which collection type stores unordered, unique values?",
        answers: ["Array", "Dictionary", "Tuple", "Set"],
        correctAnswer: "Set",
        questionImage: Image(systemName: "square.grid.3x3.fill")
    ),
    Question(
        question: "What keyword is utilized to define a constant in Swift?",
        answers: ["var", "const", "let", "static"],
        correctAnswer: "let",
        questionImage: Image(systemName: "lock.fill")
    ),
    Question(
        question: "What keyword is utilized to define a constant in Swift?",
        answers: ["var", "const", "let", "static"],
        correctAnswer: "let",
        questionImage: Image(systemName: "lock.fill")
    )
]

let mockQuiz = Quiz(
    id: UUID(),
    questions: mockQuestions,
    isPassed: false
)
