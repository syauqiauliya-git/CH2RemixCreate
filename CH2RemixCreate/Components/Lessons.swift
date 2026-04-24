//
//  Lessons.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 23/04/26.
//

import SwiftUI


struct Lesson {
    let title: String
    let description: String
    var image: Image?
    var isPassed: Bool = false
}

let mockLesson: [Lesson] = [
    Lesson(
        title: "What is a Stock?",
        description: "A stock is like owning a tiny piece of a company! If the company does well, your tiny piece becomes more valuable. It’s like sharing a pizza with friends, but instead of pizza, you share a company!",
        image: Image(systemName: "building.2.fill")
    ),
    
    Lesson(
        title: "Why Do People Buy Stocks?",
        description: "People buy stocks because they hope the company will grow and make more money. If the company becomes popular, the value of the stock can go up too! It’s like planting a seed and waiting for it to grow into a big tree 🌱",
        image: Image(systemName: "cart.fill")
    ),
    
    Lesson(
        title: "What is a Price?",
        description: "The price of a stock is how much it costs to buy one piece of a company. This price can go up and down every day, just like the weather changes ☀️🌧️",
        image: Image(systemName: "dollarsign.circle.fill")
    ),
    
    Lesson(
        title: "What is Profit?",
        description: "Profit is when you sell your stock for more money than you bought it for. That means you made extra money! But sometimes prices go down too, so you have to be careful 📉📈",
        image: Image(systemName: "chart.line.uptrend.xyaxis")
    ),
    
    Lesson(
        title: "Be Patient!",
        description: "Stocks are not a quick game. Sometimes you need to wait a long time for them to grow. Just like learning a skill, the more patient you are, the better results you might get 🎯",
        image: Image(systemName: "clock.fill")
    )
]
