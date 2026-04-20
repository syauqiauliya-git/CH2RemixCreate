//
//  ContentView.swift
//  CH2RemixCreate
//
//  Created by Syauqi Auliya M on 20/04/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        GeometryReader { proxy in
            
            let visibleWidth = proxy.size.width
            let contentWidth = proxy.size.width*2
            let contentHeight = proxy.size.height
            
            let point1: CGPoint = .init(x: -10, y: proxy.size.height)
            let point1half: CGPoint = .init(x: proxy.size.width*1/6, y: contentHeight*0.675)
            let point2 = CGPoint(x: proxy.size.width*1/3, y: contentHeight*0.4)
            let point2half = CGPoint(x: proxy.size.width*3/6, y: contentHeight*0.525)
            let point3: CGPoint = .init(x: proxy.size.width*2/3, y: contentHeight*0.65)
            let point3half = CGPoint(x: proxy.size.width*5/6, y: contentHeight*0.4)
            let point4: CGPoint = .init(x: proxy.size.width+10, y: contentHeight*0.1)
            let point5: CGPoint = .init(x: proxy.size.width+200, y: contentHeight*0.1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                ZStack {
                    Path { path in
                        let start = point1
                        let end = point2
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(.green, lineWidth: 10)
                    
                    Path { path in
                        let start = point2
                        let end = point3
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(.red, lineWidth: 10)
                    
                    Path { path in
                        let start = point3
                        let end = point4
                        path.move(to: start)
                        path.addLine(to: end)
                    }
                    .stroke(.green, lineWidth: 10)
                    
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .position(point1half)
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 50, height: 50)
                        .position(point2)
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .position(point2half)
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 50, height: 50)
                        .position(point3)
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .position(point3half)
                    Circle()
                        .fill(Color.white)
                        .strokeBorder(Color.black, lineWidth: 1)
                        .frame(width: 35, height: 35)
                        .position(point5)

                }
                .frame(width: contentWidth, height: contentHeight, alignment: .topLeading)
            }
            .frame(width: visibleWidth, height: contentHeight)

        }
        .frame(height: 250)
    }
}

#Preview {
    ContentView()
}
