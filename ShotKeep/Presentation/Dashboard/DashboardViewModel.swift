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
    
    @Published private(set) var destinationScreenshots: [Screenshot] = []
    @Published private(set) var sourceScreenshots: [Screenshot] = []
    
    private(set) var lastOrganizedAt: Date?
    
    var monitoringStatusText: String {
        isMonitoringEnabled ? "Active" : "Inactive"
    }
    
    var monitoringDescription: String {
        isMonitoringEnabled ? "Auto organizing is enabled" : "Auto organizing is disabled"
    }
    
    var monitoringStatusColor: Color {
        isMonitoringEnabled ? Color.green : Color.gray
    }
    
    var lastOrganizedText: String {
        guard let date = lastOrganizedAt else { return "Never organized" }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "Last organized \(formatter.localizedString(for: date, relativeTo: Date()))"
    }
    
    var screenshotsCapturedToday: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
            return 0
        }

        return (sourceScreenshots + destinationScreenshots)
            .filter { $0.createdAt >= startOfToday &&
                      $0.createdAt < startOfTomorrow }
            .count
    }
    
    private let bookmarkSourceUDKey = "shotkeep.source.bookmark"
    private let bookmarkDestinationUDKey = "shotkeep.destination.bookmark"
    
    private let fetchUseCase: FetchScreenshotUseCase
    private let moveAllSSUseCase: MoveAllScreenshotUseCase
    private let watcher: DispatchSourceScreenshotWatcher
    private let notificationService: NotificationService
    
    init(config: AppConfigViewModel,
         fetchUseCase: FetchScreenshotUseCase,
         moveAllSSUseCase: MoveAllScreenshotUseCase,
         watcher: DispatchSourceScreenshotWatcher,
         notificationService: NotificationService) {
        
        
        self.config = config
        self.fetchUseCase = fetchUseCase
        self.moveAllSSUseCase = moveAllSSUseCase
        self.watcher = watcher
        self.notificationService = notificationService
        
        startMonitoring(directory: config.sourceDirectory)
        isMonitoringEnabled = UserDefaults.standard.bool(forKey: StringConstants.isMonitoringEnabledUDkey)
        refreshScreenshots()
        lastOrganizedAt = UserDefaults.standard.object(forKey: StringConstants.lastOrganizedKey) as? Date

    }
    
    deinit {
        stopMonitoring()
    }
    
    
    func handleMonitoringChange() {
        UserDefaults.standard.set(isMonitoringEnabled, forKey: StringConstants.isMonitoringEnabledUDkey)
        if isMonitoringEnabled {
            moveAllScreenshots()
        }
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
        if sourceScreenshots.isEmpty { return }
        do {
            try moveAllSSUseCase.execute(
                sourceScreenshots,
                from: source,
                to: destination
            )
            
            notificationService.show(
                title: "Screenshots Organized!",
                message: "All screenshots moved to ~/\(config.destinationFolderDisplayName)."
            )
            

            refreshScreenshots()
            
            setLastOrganizedDate()
            
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
    
    func refreshScreenshots() {
        destinationScreenshots = loadScreenshots(at: config.destinationDirectory)
        sourceScreenshots = loadScreenshots(at: config.sourceDirectory)
        if !isMonitoringEnabled {
            notificationService.show(
                title: "Screenshots are in Mess!",
                message: "You just captured a screenshot, but it's yet to organized."
            )
        }
        
    }
    
    func startMonitoring(directory: URL?) {
        guard let directory else { return }
        debugPrint("Start Monitoring")
        watcher.startWatching(directory: directory) { [weak self] in
            guard let self else { return }
            debugPrint("watcher fired")
            if isMonitoringEnabled{
                moveAllScreenshots()
            }
            refreshScreenshots()
        }
    }
    
    func stopMonitoring() {
        debugPrint("Stop Monitoring")
        watcher.stopWatching()
    }
    
    func setLastOrganizedDate() {
        let now = Date()
        lastOrganizedAt = now
        UserDefaults.standard.set(now, forKey: StringConstants.lastOrganizedKey)
    }
}
