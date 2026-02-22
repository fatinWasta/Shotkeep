//
//  ScreenshotDirectoryWatching.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

import Foundation

protocol ScreenshotDirectoryWatching {
    func startWatching(directory: URL, onChange: @escaping () -> Void)
    func stopWatching()
}
