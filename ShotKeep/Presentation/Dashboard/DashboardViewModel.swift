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
    
    
    init(fetchUseCase: FetchScreenshotUseCase,
         moveAllSSUseCase: MoveAllScreenshotUseCase,
         watcher: DispatchSourceScreenshotWatcher) {
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
    
    func chooseSourceFolder() {
        if let url = chooseDirectory(
            defaultURL: sourceDirectory,
            prompt: "Select Screenshot Folder"
        ) {
            persistBookmark(for: bookmarkSourceUDKey, at: url)
            setSourceDirectory(url)
        }
    }
    
    func chooseDestinationFolder() {
        if let url = chooseDirectory(
            defaultURL: destinationDirectory,
            prompt: "Select Destination Folder"
        ) {
            persistBookmark(for: bookmarkDestinationUDKey, at: url)
            setDestinationDirectory(url)
        }
    }
    
    func restoreSourceFolderIfAvailable() {
        guard let data = UserDefaults.standard.data(forKey: bookmarkSourceUDKey) else { return }
        
        var isStale = false
        
        do {
            let url = try URL(
                resolvingBookmarkData: data,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            setSourceDirectory(url)
            
        } catch {
            debugPrint("Failed to restore bookmark:", error)
        }
    }
    
    
}

extension DashboardViewModel {
    func getSourceDirectoryPath() -> String {
        return sourceDirectory?.lastPathComponent ?? "Select a directory to read default screenshots from."
    }
}

extension DashboardViewModel {
    func setSourceDirectory(_ url: URL) {
        debugPrint("User set directory: \(url)")
        sourceDirectory = url
        
        startMonitoring(directory: url)
        updateSourceScreenshots()
    }
    
    func setDestinationDirectory(_ url: URL) {
        debugPrint("User set directory: \(url)")
        destinationDirectory = url
        
        //startMonitoring(directory: url)
        //load()
    }
}

private extension DashboardViewModel {
    
    private func chooseDirectory(
        defaultURL: URL? = nil,
        prompt: String
    ) -> URL? {
        
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        panel.prompt = prompt
        
        if let defaultURL {
            panel.directoryURL = defaultURL
        }
        
        return panel.runModal() == .OK ? panel.url : nil
    }
    
    func persistBookmark(for key:String, at url: URL) {
        do {
            let bookmark = try url.bookmarkData(
                options: [.withSecurityScope],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            UserDefaults.standard.set(bookmark, forKey: key)
            
        } catch {
            debugPrint("Failed to create bookmark:", error)
        }
    }
    
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
