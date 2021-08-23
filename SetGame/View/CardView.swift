//
//  CardView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/22.
//

import SwiftUI

struct CardView: View {
    var card: Card
    var matchingStatus: SetGameViewModel.MatchingStatus = .none
    
    var body: some View {
        ZStack {
            cardBorder
            GeometryReader { geometry in
                let itemWidth = geometry.size.height / 3 * 0.6
                VStack(spacing: itemWidth / 5) {
                    Spacer()
                    ForEach(0..<numberOfShapes, id: \.self) { _ in
                        CardShape(shape: card.shape)
                            .shaded(by: card.shading)
                            .foregroundColor(symbolColor)
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
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: borderWidth)
            .foregroundColor(borderColor)
    }
    
    private var borderWidth: CGFloat {
        switch matchingStatus {
        case .selected:
            return 4
        default:
            return 1.5
        }
    }
    
    private var borderColor: Color {
        switch matchingStatus {
        case .selected:
            return .blue
        case .matched:
            return .yellow
        case .mismatched:
            return .red
        default:
            return .gray
        }
    }
    
    private var symbolColor: Color {
        switch card.color {
        case .option1:
            return .green
        case .option2:
            return .purple
        case .option3:
            return .red
        }
    }
    
    var numberOfShapes: Int {
        switch card.number {
        case .option1:
            return 1
        case .option2:
            return 2
        case .option3:
            return 3
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(shape: .option1, color: .option1, shading: .option1, number: .option3))
            .frame(width: 45, height: 65, alignment: .center)
    }
}
