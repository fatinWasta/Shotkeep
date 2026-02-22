    //
    //  ShotKeepViewModel.swift
    //  ShotKeep
    //
    //  Created by Fatin on 22/02/26.
    //
import Combine
import Foundation
import AppKit

final class ShotKeepViewModel: ObservableObject {
    
    
    @Published private(set) var screenshots: [Screenshot] = []
    @Published private(set) var sourceDirectory: URL?
    
    private let bookmarkUDKey = "shotkeep.source.bookmark"
    
    private let fetchUseCase: FetchScreenshotUseCase
    private let moveAllSSUseCase: MoveAllScreenshotUseCase
    private let watcher: DispatchSourceScreenshotWatcher
    
    
    init(fetchUseCase: FetchScreenshotUseCase,
         moveAllSSUseCase: MoveAllScreenshotUseCase,
         watcher: DispatchSourceScreenshotWatcher) {
        self.fetchUseCase = fetchUseCase
        self.moveAllSSUseCase = moveAllSSUseCase
        self.watcher = watcher
        load()
    }
    
    deinit {
        watcher.stopWatching()
    }
    
    func load() {
        guard let directory = sourceDirectory else { return }
        
        let didStartAccessing = directory.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                directory.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            let fetchedScreenshots = try fetchUseCase.execute(from: directory)
            screenshots = fetchedScreenshots
        } catch {
            debugPrint("Error fetching screenshots:", error)
        }
    }
    
    func moveAllScreenshots(to destination: URL) {
        guard let source = sourceDirectory else { return }
        
        let didStartAccessing = source.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                source.stopAccessingSecurityScopedResource()
            }
        }
        
        do {
            try moveAllSSUseCase.execute(screenshots, from: source, to: destination)
            load()
        } catch {
            debugPrint("Error moving screenshots:", error)
        }
    }
    
    func chooseSourceFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = false
        
        if panel.runModal() == .OK, let url = panel.url {
            persistBookmark(for: url)
            setSourceDirectory(url)
        }
    }
    
    func restoreSourceFolderIfAvailable() {
        guard let data = UserDefaults.standard.data(forKey: bookmarkUDKey) else { return }
        
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

extension ShotKeepViewModel {
    func setSourceDirectory(_ url: URL) {
        debugPrint("User set directory: \(url)")
        sourceDirectory = url
        
        startMonitoring(directory: url)
        load()
    }
}

private extension ShotKeepViewModel {
    
    
    func persistBookmark(for url: URL) {
        do {
            let bookmark = try url.bookmarkData(
                options: [.withSecurityScope],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            UserDefaults.standard.set(bookmark, forKey: bookmarkUDKey)
            
        } catch {
            debugPrint("Failed to create bookmark:", error)
        }
    }
    
    func startMonitoring(directory: URL) {
        watcher.startWatching(directory: directory) { [weak self] in
            debugPrint("watcher fired")
            self?.load()
        }
    }
}
