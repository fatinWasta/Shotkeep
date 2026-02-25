//
//  RootView.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case settings
}

struct RootView: View {
    
    @EnvironmentObject private var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            DashboardView()
                .environmentObject(coordinator)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .settings:
                        SettingsView()
                            .environmentObject(coordinator)
                    }
                }
        }
        .toolbar(.hidden, for: .windowToolbar)
    }
}

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
}
