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
        ZStack {
            let rr = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            rr
                    .fill(Color.cardBackground)
                    .overlay(
                            rr
                                    .stroke(lineWidth: strokeWidth)
                                    .foregroundColor(strokeColor)
                    )
            if rotation < 90 {
                content.opacity(1)
            } else {
                Text("❓").font(.largeTitle)
            }
        }
                .rotation3DEffect(
                        Angle.degrees(rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0)
                )
    }

    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 10
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