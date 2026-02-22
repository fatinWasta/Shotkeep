//
//  ShotKeepTests.swift
//  ShotKeepTests
//
//  Created by Fatin on 21/02/26.
//

import Testing
import Foundation
@testable import ShotKeep

struct ShotKeepTests {
    let mockRepo = MockScreenshotRepository()
    
    @Test func test_getTotalScreenshotCount()  {
        let mockRepo = MockScreenshotRepository()
        mockRepo.screenshots = [Screenshot(url: URL(fileURLWithPath: "/a.png"), createdAt: Date()),
                                     Screenshot(url: URL(fileURLWithPath: "/b.png"), createdAt: Date()) ]
        
        let fetch = FetchScreenshotUseCase(repository: mockRepo)
        let moveAllSSUseCase = MoveAllScreenshotUseCase(repository: mockRepo)

        let vm = ScreenshotViewModel(fetchUseCase: fetch,
                                           moveAllSSUseCase: moveAllSSUseCase)
        
        vm.load()
         
         #expect(vm.screenshots.count == 2, "Expected 2 screenshots")
        
    }
    
    @Test func test_screenshotsAreEmpty() {
        mockRepo.screenshots = []
        
        let fetch = FetchScreenshotUseCase(repository: mockRepo)
        let moveAllSSUseCase = MoveAllScreenshotUseCase(repository: mockRepo)

        let vm = ScreenshotViewModel(fetchUseCase: fetch,
                                           moveAllSSUseCase: moveAllSSUseCase)
        
        vm.load()
         
         #expect(vm.screenshots.count == 0, "Expected 0 screenshots")
        
    }
    
    @Test func test_moveAllScreenshots() {
        mockRepo.screenshots = [Screenshot(url: URL(fileURLWithPath: "/a.png"), createdAt: Date())]
        
        let fetchUseCase = FetchScreenshotUseCase(repository: mockRepo)
        let moveAllSSUseCase = MoveAllScreenshotUseCase(repository: mockRepo)
        
        let vm = ScreenshotViewModel(fetchUseCase: fetchUseCase,
                                             moveAllSSUseCase: moveAllSSUseCase)
        
        vm.load()
        
        vm.moveAllScreenshots(to:  URL(fileURLWithPath: "/Users/fatin/Desktop/ShotKeep"))
        
        #expect(vm.screenshots.isEmpty, "Screenshots are moved and empty")
                                
    }

}
