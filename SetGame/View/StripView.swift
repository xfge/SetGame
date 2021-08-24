//
//  StripView.swift
//  SetGame
//
//  Created by 葛笑非 on 2021/8/24.
//

import SwiftUI

struct StripView<ContentShape: Shape>: View {
    var shape: ContentShape
    var color: Color
    
    var body: some View {
        GeometryReader(content: { geometry in
            let numberOfStrips = Int(geometry.size.width / 6.5 + 1)
            HStack(spacing: 0) {
                Color(white: 0)
                ForEach(0..<numberOfStrips, id: \.self) { number in
                    color.frame(width: stripWidth)
                    Color(white: 0)
                }
            }
        })

        .mask(shape)
        .overlay(shape.stroke(color, lineWidth: borderWidth))
    }
    
    let stripWidth: CGFloat = 1
    let borderWidth: CGFloat = 2
}

struct StripView_Previews: PreviewProvider {
    static var previews: some View {
        StripView(shape: Capsule(), color: .blue)
    }
}
