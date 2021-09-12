//
//  CardView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var borderColor: Color
    var borderWidth: CGFloat
    
    var body: some View {
        ZStack {
            cardBorder
            GeometryReader { geometry in
                let itemWidth = geometry.size.height / 3 * 0.6
                VStack(spacing: itemWidth / 5) {
                    Spacer()
                    ForEach(0..<card.symbolCount, id: \.self) { _ in
                        cardShape
                    }
                    .aspectRatio(2, contentMode: .fit)
                    .frame(width: geometry.size.width, height: itemWidth)
                    Spacer()
                }
            }
        }
    }
    
    var cardBorder: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: borderWidth)
            .foregroundColor(borderColor)
    }
    
    var cardShape: some View {
        CardShape(shape: card.shape)
            .shaded(by: card.shading, with: card.color)
            .foregroundColor(card.color)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            card: Card(variant1: .option1, variant2: .option1, variant3: .option1, variant4: .option3, id: 0),
            borderColor: .gray,
            borderWidth: 1.5
        )
            .frame(width: 100, height: 150, alignment: .center)
    }
}
