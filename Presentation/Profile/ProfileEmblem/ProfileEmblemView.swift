//
//  SwiftUIView.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI

struct ProfileEmblemView: View {
    let emblems: [String]
    let colums: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        GeometryReader { geometry in
            LazyVGrid(columns: colums, spacing: 2) {
                ForEach(emblems, id: \.self) { emblem in
                    EmblemCell(emblem: emblem, size: geometry.size.width / 3 - 2)
                }
            }
            .padding(.horizontal, 1)
        }
    }
}
