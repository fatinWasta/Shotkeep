//
//  CardView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    
    let shadowRadius: CGFloat
    let cornerRadius: CGFloat
    let backgroundColor: Color
    
    init(shadowRadius: CGFloat = 0.0,
         cornerRadius: CGFloat = 12,
         backgroundColor: Color = Color(NSColor.windowBackgroundColor),
         @ViewBuilder content: () -> Content
    ) {
        
        self.content = content()
        self.shadowRadius = shadowRadius
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius,
                                 style: .continuous)
                    .fill(backgroundColor)
            )
            .shadow(radius: shadowRadius)
    }
}
