//
//  MockScreenshotRepository.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

@testable import ShotKeep
import Foundation


final class MockScreenshotRepository: ScreenshotRepository {
   
    
    var screenshots: [Screenshot] = []
    
    func fetchScreenshot() throws -> [Screenshot] {
        screenshots
    }
    
    func move(screenshots: [Screenshot], to directory: URL) throws {
        self.screenshots.removeAll { screenshots.contains($0) }
    }

    
    
}
