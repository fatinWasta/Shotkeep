//
//  DispatchSourceScreenshotWatcher.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//

import Foundation

final class DispatchSourceScreenshotWatcher: ScreenshotDirectoryWatching {
    
    private var source: DispatchSourceFileSystemObject?
    private var fileDescriptor: CInt = -1
    
    
    func startWatching(directory: URL, onChange: @escaping () -> Void) {
        let desktopURL = directory
        
        fileDescriptor = open(desktopURL.path, O_EVTONLY)
        
        guard fileDescriptor >= 0 else { return }
        
        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: [.write, .rename, .delete],
            queue: DispatchQueue.global()
        )
        
        source?.setEventHandler {
            DispatchQueue.main.async {
                onChange()
            }
        }
        
        source?.setCancelHandler {
            close(self.fileDescriptor)
            self.fileDescriptor = -1
        }
        
        source?.resume()
    }
    
    func stopWatching() {
        source?.cancel()
        source = nil
    }
}
