//
//  MockWatcher.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

@testable import ShotKeep

final class MockWatcher: ScreenshotDirectoryWatching {
    func startWatcing(onChange: @escaping () -> Void) {
        self.onChange = onChange
    }
    
    func stopWatching() {}
    
    var onChange: (() -> Void)?
    
    
}
