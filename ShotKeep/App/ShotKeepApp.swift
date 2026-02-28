//
//  ShotKeepApp.swift
//  ShotKeep
//
//  Created by Fatin on 21/02/26.
//

import SwiftUI
import AppKit

@main
struct ShotKeepApp: App {
    
    @StateObject private var coordinator = NavigationCoordinator()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)

        }
        .windowResizability(.contentSize)
    }
    
    
    
    
}
