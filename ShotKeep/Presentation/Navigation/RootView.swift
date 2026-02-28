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
    
    @StateObject private var configVM: AppConfigViewModel
    @StateObject private var dashboardVM: DashboardViewModel
    
    
    init() {
        let repository = FileSystemScreenshotRepository()
        
        let fetchUseCase = FetchScreenshotUseCase(repository: repository)
        let moveUseCase = MoveAllScreenshotUseCase(repository: repository)
        
        let watcher = DispatchSourceScreenshotWatcher()
        let notificationService = SystemNotificationService()
        
        let config = AppConfigViewModel()
        
        let dashboard = DashboardViewModel(
            config: config,
            fetchUseCase: fetchUseCase,
            moveAllSSUseCase: moveUseCase,
            watcher: watcher,
            notificationService: notificationService
        )
        
        _configVM = StateObject(wrappedValue: config)
        _dashboardVM = StateObject(wrappedValue: dashboard)
    }
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            DashboardView(viewModel: dashboardVM)
                .environmentObject(coordinator)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .settings:
                        SettingsView(config: configVM)
                            .environmentObject(coordinator)
                    }
                }
        }
        .toolbar(.hidden, for: .windowToolbar)
    }
}

