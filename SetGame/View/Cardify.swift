//
// Created by 葛笑非 on 2021/9/19.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    init(isFaceUp: Bool, strokeWidth: CGFloat, strokeColor: Color) {
        rotation = isFaceUp ? 0 : 180
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
    }

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    var rotation: Double
    var strokeWidth: CGFloat
    var strokeColor: Color

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            ZStack {
                cardFrame
                    .animation(.none, value: strokeColor)
                if rotation < 90 {
                    content.opacity(1)
                } else {
                    Image("Uno")
                        .resizable()
                        .frame(
                            width: geometry.size.width * DrawingConstants.logoRatio,
                            height: geometry.size.height * DrawingConstants.logoRatio
                        )
                        .rotation3DEffect(
                            Angle.degrees(180),
                            axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                }
            }
                .rotation3DEffect(
                    Angle.degrees(rotation),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
        }
    }

    var cardFrame: some View {
        let roundedRect = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
        return roundedRect
            .fill(Color.cardBackground)
            .overlay(
                roundedRect
                    .stroke(lineWidth: strokeWidth)
                    .foregroundColor(strokeColor)
            )
    }

    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
        static let logoRatio: CGFloat = 0.75
    }
}

extension View {
    func cardify(isFaceUp: Bool, strokeWidth: CGFloat, strokeColor: Color) -> some View {
        self.modifier(Cardify(
                isFaceUp: isFaceUp,
                strokeWidth: strokeWidth,
                strokeColor: strokeColor)
        )
    }
}
