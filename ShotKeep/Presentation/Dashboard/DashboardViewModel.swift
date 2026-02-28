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

final class DashboardViewModel: ObservableObject {
    @ObservedObject var config: AppConfigViewModel
    
    @Published var isMonitoringEnabled: Bool = false {
        didSet {
            handleMonitoringChange()
        }
    }
    
    @Published private(set) var sourceScreenshots: [Screenshot] = []
    @Published private(set) var sourceDirectory: URL?
    @Published private(set) var destinationDirectory: URL?
    
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
        
        sourceScreenshots = loadScreenshots(at: sourceDirectory)
    }
    
    deinit {
        watcher.stopWatching()
    }
    
    func handleMonitoringChange() {
        debugPrint("handle monitor change")
        guard let sourceDirectory else { return }
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
    
    func moveAllScreenshots(to destination: URL?) {
        guard let destination else { return }
        guard let source = sourceDirectory else { return }
        
        let didAccessSource = source.startAccessingSecurityScopedResource()
        let didAccessDestination = destination.startAccessingSecurityScopedResource()
        
        defer {
            if didAccessSource { source.stopAccessingSecurityScopedResource() }
            if didAccessDestination { destination.stopAccessingSecurityScopedResource() }
        }
        
        guard didAccessSource else {
            debugPrint("No permission for source folder")
            return
        }
        
        guard didAccessDestination else {
            debugPrint("No permission for destination folder")
            return
        }
        
        do {
            try moveAllSSUseCase.execute(
                sourceScreenshots,
                from: source,
                to: destination
            )
            
            updateSourceScreenshots()
            
        } catch {
            debugPrint("Error moving screenshots:", error)
        }
    }
    
    
}

private extension DashboardViewModel {
    
    func updateSourceScreenshots() {
        sourceScreenshots = self.loadScreenshots(at: self.sourceDirectory)
    }
    
    func startMonitoring(directory: URL) {
        debugPrint("Start Monitoring")
        watcher.startWatching(directory: directory) { [weak self] in
            guard let self else { return }
            debugPrint("watcher fired")
           updateSourceScreenshots()
        }
    }
    
    private func stopMonitoring() {
        debugPrint("Stop Monitoring")
        watcher.stopWatching()
    }
}
