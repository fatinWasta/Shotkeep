//
//  FetchScreenshotUseCase.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

import Foundation
struct FetchScreenshotUseCase {
    private let repository: ScreenshotRepository
    
    init(repository: ScreenshotRepository) {
        self.repository = repository
    }
    
    func execute(from source: URL) throws -> [Screenshot] {
        try repository.fetchScreenshots(from: source)
    }
}
