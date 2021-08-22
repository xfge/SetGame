//
//  CardView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            cardBorder
            GeometryReader { geometry in
                let itemWidth = geometry.size.height / 3 * 0.6
                VStack(spacing: itemWidth / 5) {
                    Spacer()
                    ForEach(0..<card.numberOfShapes) { _ in
                        CardShape(shape: card.shape)
                            .shaded(by: card.shading)
                            .foregroundColor(color(for: card))
                    }
                    .aspectRatio(2, contentMode: .fit)
                    .frame(width: geometry.size.width, height: itemWidth)
                    Spacer()
                }
//                .padding()
//                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            }

        }
    }
    
    @ViewBuilder
    var cardBorder: some View {
        let strokeWith: CGFloat = isSelected ? 4 : 1.5
        let color: Color = isSelected ? .blue : .gray
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: strokeWith)
            .foregroundColor(color)
    }
    
    func color(for card: Card) -> Color {
        switch card.color {
        case .option1:
            return .green
        case .option2:
            return .purple
        case .option3:
            return .red
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(shape: .option1, color: .option1, shading: .option1, number: .option3), isSelected: true)
            .frame(width: 45, height: 65, alignment: .center)
    }
}
