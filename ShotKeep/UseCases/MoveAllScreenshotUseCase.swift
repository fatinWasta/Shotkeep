//
//  MoveAllScreenshotUseCase.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

import Foundation

struct MoveAllScreenshotUseCase {
    private let repository: ScreenshotRepository
    
    init(repository: ScreenshotRepository) {
        self.repository = repository
    }
    
    
    func execute(_ screenshots:[Screenshot], from source: URL, to destination: URL) throws {
        try repository.move(screenshots, from: source, to: destination)
    }
    
}
