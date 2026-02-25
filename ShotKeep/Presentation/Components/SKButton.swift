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
    let action: () -> Void
    
    var backgroundColor: Color = Color(.blue)
    var titleColor: Color = .primary
    var isEnabled: Bool = true
    var cornerRadius: CGFloat = 8
    
    // MARK: - Body
    
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
             image:Image(systemName: "folder")) {
        debugPrint("Tapped")
    }
}
