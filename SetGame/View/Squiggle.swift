//
//  Squiggle.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/24.
//

import SwiftUI

struct Squiggle: Shape {
  func path(in rect: CGRect) -> Path {
    let w = rect.width
    let h = rect.height
    let point1 = CGPoint(x: 0, y: 0.7 * h)
    let point2 = CGPoint(x: 0.4 * w, y: 0.05 * h)
    let point3 = CGPoint(x: 0.95 * w, y: 0.1 * h)
    let point4 = CGPoint(x: 0.6 * w, y: 0.9 * h)
    let point5 = CGPoint(x: 0.3 * w, y: 0.75 * h)

    var p = Path()

    p.move(to: point1)

    p.addCurve(
      to: point2,
      control1: CGPoint(x: -0.1 * w, y: 0.1 * h),
      control2: CGPoint(x: 0.25 * rect.width, y: -0.1 * h)
    )

    p.addCurve(
      to: point3,
      control1: CGPoint(x: 0.8 * rect.width, y: 0.5 * rect.height),
      control2: CGPoint(x: 0.82 * rect.width, y: -0.3 * rect.height)
    )

    p.addCurve(
      to: point4,
      control1: CGPoint(x: 1.0 * rect.width, y: 0.35 * rect.height),
      control2: CGPoint(x: 0.95 * rect.width, y: 1.0 * rect.height)
    )

    p.addCurve(
      to: point5,
      control1: CGPoint(x: 0.45 * rect.width, y: 0.85 * rect.height),
      control2: CGPoint(x: 0.4 * rect.width, y: 0.7 * rect.height)
    )

    p.addCurve(
      to: point1,
      control1: CGPoint(x: 0.2 * rect.width, y: 0.8 * rect.maxY),
      control2: CGPoint(x: 0.1 * rect.width, y: 1.2 * rect.height)
    )

    return p
  }
}

struct Squiggle_Previews: PreviewProvider {
  static var previews: some View {
    Squiggle()
      .frame(width: 600, height: 300)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
