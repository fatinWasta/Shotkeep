//
//  AppConfigViewModel.swift
//  ShotKeep
//
//  Created by Fatin on 28/02/26.
//

import SwiftUI
import Combine

final class AppConfigViewModel: ObservableObject {
    
    @Published var sourceDirectory: URL?
    @Published var destinationDirectory: URL?
    
    var sourceFolderDisplayName: String {
        sourceDirectory?.lastPathComponent ?? "Not selected"
    }

    var destinationFolderDisplayName: String {
        destinationDirectory?.lastPathComponent ?? "Not selected"
    }
    
    var isConfigured: Bool {
        sourceDirectory != nil && destinationDirectory != nil
    }
    
    
    init() {
        restoreBookmarksIfAvailable()
    }
    
    func restoreBookmarksIfAvailable() {
        sourceDirectory = restoreBookmark(forKey: StringConstants.bookmarkSourceUDKey)
        destinationDirectory = restoreBookmark(forKey: StringConstants.bookmarkDestinationUDKey)
    }
    
    
    func saveBookmark(for url: URL, key: String) throws {
        let bookmarkData = try url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        
        UserDefaults.standard.set(bookmarkData, forKey: key)
    }
    
}

private extension AppConfigViewModel {
    
    func restoreBookmark(forKey key: String) -> URL? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        var isStale = false
        
        do {
            let url = try URL(
                resolvingBookmarkData: data,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            if isStale {
                try saveBookmark(for: url, key: key)
            }
            
            if url.startAccessingSecurityScopedResource() {
                return url
            } else {
                return nil
            }
            
        } catch {
            debugPrint("Failed to restore bookmark for key:", key, error)
            return nil
        }
    }
    
}

extension AppConfigViewModel {
    func updateSource(_ url: URL) {
        sourceDirectory = url
        do {
            try saveBookmark(for: url, key: StringConstants.bookmarkSourceUDKey)

        } catch {
            debugPrint("Could not bookmark the source DIR")
        }
    }
    
    func updateDestination(_ url: URL) {
        destinationDirectory = url
        do {
            try saveBookmark(for: url, key: StringConstants.bookmarkDestinationUDKey)

        } catch {
            debugPrint("Could not bookmark the destination DIR")
        }

    }
    
    
    func chooseSourceFolder() {
        if let url = chooseDirectory(
            defaultURL: sourceDirectory,
            prompt: "Select Screenshot Folder"
        ) {
            updateSource(url)
        }
    }
    
    func chooseDestinationFolder() {
        if let url = chooseDirectory(
            defaultURL: destinationDirectory,
            prompt: "Select Destination Folder"
        ) {
            updateDestination(url)
        }
    }
    
    
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
}
