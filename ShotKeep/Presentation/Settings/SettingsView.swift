//
//  SettingsView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//


import SwiftUI

struct SettingsView : View {
    @EnvironmentObject private var coordinator: NavigationCoordinator

    var body: some View {
        VStack {
            TitleView(title: "Settings",
                      subTitle: "Configure file locations",
                      leadingImageName: "arrow.left")
            
            Divider()
                .padding([.leading, .trailing])
            
            CardView(backgroundColor: .gray) {
                
            }
            
           Spacer()
        }
        .frame(width: 400, height: 500)
    }
    
}

#Preview {
    SettingsView()
        .environmentObject(NavigationCoordinator())
}

