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

struct Question {
    let question: String
    let answers: [String]
    let correctAnswer: String
    var questionImage: Image?
}

// MARK: - Mock Data Set 1: Stock Basics
let mockQuestions1: [Question] = [
    Question(
        question: "SET1 What does it mean when you buy a 'stock' in a company?",
        answers: ["You work there now", "You own a tiny piece of the company", "You get free toys", "You become the boss"],
        correctAnswer: "You own a tiny piece of the company",
        questionImage: Image(systemName: "chart.pie.fill")
    ),
    Question(
        question: "Why do companies sell pieces of themselves (stocks) to people?",
        answers: ["To raise money to grow bigger", "Because they are bored", "To buy more snacks", "To pay for a vacation"],
        correctAnswer: "To raise money to grow bigger",
        questionImage: Image(systemName: "building.2.fill")
    ),
    Question(
        question: "If you buy a stock for $5 and sell it later for $10, what did you just make?",
        answers: ["A mistake", "A friend", "A profit", "A loss"],
        correctAnswer: "A profit",
        questionImage: Image(systemName: "dollarsign.circle.fill")
    ),
    Question(
        question: "What do we call the collection of all the different stocks you own?",
        answers: ["A backpack", "A piggy bank", "A toy box", "A portfolio"],
        correctAnswer: "A portfolio",
        questionImage: Image(systemName: "briefcase.fill")
    )
]

// MARK: - Mock Data Set 2: The Stock Market
let mockQuestions2: [Question] = [
    Question(
        question: "SET2 Where do people go to buy and sell stocks?",
        answers: ["The Supermarket", "The Toy Store", "The Stock Market", "The Bakery"],
        correctAnswer: "The Stock Market",
        questionImage: Image(systemName: "cart.fill")
    ),
    Question(
        question: "If a company invents the best new video game ever, what might happen to its stock price?",
        answers: ["It goes up!", "It goes down to zero", "It turns into a potato", "Nothing happens"],
        correctAnswer: "It goes up!",
        questionImage: Image(systemName: "arrow.up.right.circle.fill")
    ),
    Question(
        question: "Is it a smart idea to put all your money into just ONE company's stock?",
        answers: ["Yes, it's a sure thing!", "No, it's safer to mix them up", "Only if it's a candy company", "Yes, it's easier to count"],
        correctAnswer: "No, it's safer to mix them up",
        questionImage: Image(systemName: "basket.fill")
    ),
    Question(
        question: "What animal is used to describe a stock market that is going UP and doing great?",
        answers: ["A sleepy bear", "A charging bull", "A fast cheetah", "A flying bird"],
        correctAnswer: "A charging bull",
        questionImage: Image(systemName: "chart.line.uptrend.xyaxis")
    )
]

// MARK: - 5 Demo Quizzes
let mockQuizzes: [Quiz] = [
    Quiz(
        id: UUID(),
        questions: mockQuestions1,
        isPassed: false
    ),
    Quiz(
        id: UUID(),
        questions: mockQuestions2,
        isPassed: false
    ),
    Quiz(
        id: UUID(),
        questions: mockQuestions1, // Reusing Set 1
        isPassed: false
    ),
    Quiz(
        id: UUID(),
        questions: mockQuestions2, // Reusing Set 2
        isPassed: false
    ),
    Quiz(
        id: UUID(),
        questions: mockQuestions1, // Reusing Set 1
        isPassed: false
    )
]
