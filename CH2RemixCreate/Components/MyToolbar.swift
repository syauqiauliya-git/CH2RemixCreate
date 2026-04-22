//
//  MyToolbar.swift
//  CH2RemixCreate
//
//  Created by Gleenryan on 20/04/26.
//

import SwiftUI

struct MyToolbar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            VStack(alignment: .leading) {
                Text("Stocks")
                Text("16 April")
                    .foregroundStyle(.gray)
            }
            .fixedSize()
            .font(.title.bold())
            
            
        }
        .sharedBackgroundVisibility(.hidden)

        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
            }

            Menu {
                Button("Search") {}
                Button("Another action") {}
                Button("Something else") {}
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}


