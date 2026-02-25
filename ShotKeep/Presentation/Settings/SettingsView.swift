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
            HStack {
                Button("Back") {
                    coordinator.pop()
                }
                Text("Settings View")
            }
        }
        .frame(width: 400, height: 500)
    }
    
}
