//
//  Button.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import SwiftUI

import SwiftUI

struct SKButton: View {
    
    // MARK: - Public API
    
    let title: String
    let image: Image?
    let width: CGFloat?
    let height: CGFloat?
    var backgroundColor: Color
    var titleColor: Color
    var isEnabled: Bool
    var cornerRadius: CGFloat
    
    let action: () -> Void

    // MARK: - Body
    
    init(
        title: String,
        image: Image? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        backgroundColor: Color = Color(.blue),
        titleColor: Color = .primary,
        isEnabled: Bool = true,
        cornerRadius: CGFloat = 8,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.isEnabled = isEnabled
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                
                if let image {
                    image
                }
                
                Text(title)
            }
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(titleColor)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .padding(.vertical, 8)
        }
        .frame(width: width, height: height)
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor)
        )
        .opacity(isEnabled ? 1.0 : 0.5)
        .disabled(!isEnabled)
    }
}

#Preview {
    SKButton(title: "Tap Me",
             image: Image(systemName: "folder"),
             width: 200,
             height: 40) {
        debugPrint("Tapped")
    }
}
