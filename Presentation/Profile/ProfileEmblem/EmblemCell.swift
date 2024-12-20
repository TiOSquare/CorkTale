//
//  EmblemCell.swift
//  Presentation
//
//  Created by Finley on 12/13/24.
//

import SwiftUI

struct EmblemCell: View {
    let emblem: String
    let size: CGFloat
    
    var body: some View {
        VStack {
            Image(emblem)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipped()
        }
    }
}
