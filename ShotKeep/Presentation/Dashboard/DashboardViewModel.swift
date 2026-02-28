//
//  DashboardViewModel.swift
//  ShotKeep
//
//  Created by Fatin on 25/02/26.
//

import Foundation
import Combine
import AppKit
import SwiftUI

struct DashboardAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

final class DashboardViewModel: ObservableObject {
    @ObservedObject var config: AppConfigViewModel
    @Published var activeAlert: DashboardAlert?
    
    @Published var isMonitoringEnabled: Bool = false {
        didSet {
            handleMonitoringChange()
        }
    }
    
    var monitoringStatusText: String {
        isMonitoringEnabled ? "Active" : "Inactive"
    }
    
    var monitoringDescription: String {
        isMonitoringEnabled ? "Auto organizing is enabled" : "Auto organizing is disabled"
    }
    
    var monitoringStatusColor: Color {
        isMonitoringEnabled ? Color.green : Color.gray
    }
    
    private let bookmarkSourceUDKey = "shotkeep.source.bookmark"
    private let bookmarkDestinationUDKey = "shotkeep.destination.bookmark"
    
    private let fetchUseCase: FetchScreenshotUseCase
    private let moveAllSSUseCase: MoveAllScreenshotUseCase
    private let watcher: DispatchSourceScreenshotWatcher
    
    
    init(config: AppConfigViewModel,
         fetchUseCase: FetchScreenshotUseCase,
         moveAllSSUseCase: MoveAllScreenshotUseCase,
         watcher: DispatchSourceScreenshotWatcher) {
        self.config = config
        self.fetchUseCase = fetchUseCase
        self.moveAllSSUseCase = moveAllSSUseCase
        self.watcher = watcher
        
        //sourceScreenshots = loadScreenshots(at: config.sourceDirectory)
        isMonitoringEnabled = UserDefaults.standard.bool(forKey: StringConstants.isMonitoringEnabledUDkey)
        if isMonitoringEnabled {
           
        }
    }
    
    deinit {
        watcher.stopWatching()
    }
    
    
    func handleMonitoringChange() {
        guard let sourceDirectory = config.sourceDirectory else { return }
        UserDefaults.standard.set(isMonitoringEnabled, forKey: StringConstants.isMonitoringEnabledUDkey)
        isMonitoringEnabled ? startMonitoring(directory: sourceDirectory) : stopMonitoring()
    }
    
    func loadScreenshots(at directory: URL?) -> [Screenshot] {
        guard let directory  else { return  [] }
        
        let didStartAccessing = directory.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                directory.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            let fetchedScreenshots = try fetchUseCase.execute(from: directory)
            return fetchedScreenshots
        } catch {
            debugPrint("Error fetching screenshots:", error)
            return []
        }
    }
    
    func moveAllScreenshots() {
        guard let source = config.sourceDirectory else {
            activeAlert = DashboardAlert(
                title: "Missing Source Folder",
                message: "Please select a source folder first."
            )
            return
        }
        
        guard let destination = config.destinationDirectory else {
            activeAlert = DashboardAlert(
                title: "Missing Destination Folder",
                message: "Please select a destination folder first."
            )
            return
        }
        
        
        let didAccessSource = source.startAccessingSecurityScopedResource()
        let didAccessDestination = destination.startAccessingSecurityScopedResource()
        
        defer {
            if didAccessSource { source.stopAccessingSecurityScopedResource() }
            if didAccessDestination { destination.stopAccessingSecurityScopedResource() }
        }
        
        guard didAccessSource else {
            activeAlert = DashboardAlert(
                title: "Permission Error",
                message: "Unable to access selected folders."
            )
            return
        }
        
        guard didAccessDestination else {
            activeAlert = DashboardAlert(
                title: "Permission Error",
                message: "Unable to access selected folders."
            )
            return
        }
        let sourceScreenshots = self.loadScreenshots(at: config.sourceDirectory)
        do {
            try moveAllSSUseCase.execute(
                sourceScreenshots,
                from: source,
                to: destination
            )
            
            activeAlert = DashboardAlert(
                title: "Your Screenshots Are Safe!",
                message: "All screenshots were moved successfully to ~/\(config.destinationFolderDisplayName)."
            )
            
            
        } catch {
            activeAlert = DashboardAlert(
                title: "Move Failed",
                message: error.localizedDescription
            )
            debugPrint("Error moving screenshots:", error)
        }
    }
    
    
}

private extension DashboardViewModel {
    
//    func updateSourceScreenshots() {
//        sourceScreenshots = self.loadScreenshots(at: config.sourceDirectory)
//        debugPrint("Screenshot updated:\(sourceScreenshots.count)")
//    }
    
    func startMonitoring(directory: URL) {
        debugPrint("Start Monitoring")
        watcher.startWatching(directory: directory) { [weak self] in
            guard let self else { return }
            debugPrint("watcher fired")
            moveAllScreenshots()
        }
    }
    
    private func stopMonitoring() {
        debugPrint("Stop Monitoring")
        watcher.stopWatching()
    }
}
