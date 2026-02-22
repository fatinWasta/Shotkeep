//
//  FileSystemScreenshotRepository.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

import Foundation

final class FileSystemScreenshotRepository: ScreenshotRepository {
    
    private let fileManager: FileManager
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func fetchScreenshots(from source: URL) throws -> [Screenshot] {
        let files = try fileManager.contentsOfDirectory(
            at: source,
            includingPropertiesForKeys: [.creationDateKey, .isRegularFileKey],
            options: [.skipsHiddenFiles]
        )
        
        let allowedExtensions = ["png", "jpg", "jpeg"]
        
        return try files.compactMap { url -> Screenshot? in
            guard allowedExtensions.contains(url.pathExtension.lowercased()),
                  url.lastPathComponent.contains("Screenshot") else {
                return nil
            }
            
            let values = try url.resourceValues(forKeys: [.creationDateKey])
            guard let creationDate = values.creationDate else { return nil }
            
            return Screenshot(url: url, createdAt: creationDate)
        }
    }
    
    func move(_ screenshots: [Screenshot],
              from source: URL,
              to destination: URL) throws {
        
        if !fileManager.fileExists(atPath: source.path) == false {
            try fileManager.createDirectory(at: destination, withIntermediateDirectories: true)
        }
        
        for screenshot in screenshots {
            let destURL = destination.appendingPathComponent(screenshot.url.lastPathComponent)
            
            try? fileManager.removeItem(at: destURL)
            try fileManager.moveItem(at: screenshot.url, to: destURL)
            
        }
        
    }
    
}
