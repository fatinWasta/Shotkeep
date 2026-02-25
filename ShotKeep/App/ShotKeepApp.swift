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
    
    private let viewModel: ShotKeepViewModel
    
    init() {
        
        let repository = FileSystemScreenshotRepository()
        
        let fetchUseCase = FetchScreenshotUseCase(repository: repository)
        let moveUseCase = MoveAllScreenshotUseCase(repository: repository)
        
        let watcher = DispatchSourceScreenshotWatcher()
        
        self.viewModel = ShotKeepViewModel(
            fetchUseCase: fetchUseCase,
            moveAllSSUseCase: moveUseCase,
            watcher: watcher
        )
        viewModel.restoreSourceFolderIfAvailable()
    }
    
    var body: some Scene {
        WindowGroup {
            //ShotKeepView(viewModel: viewModel)
            DashboardView()
        }
        
        Settings {
            SettingsView()
        }
    }
    
    
    
    
}
