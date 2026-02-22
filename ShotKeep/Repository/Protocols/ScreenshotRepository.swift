//
//  ScreenshotRepository.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//
import Foundation

protocol ScreenshotRepository {
    func fetchScreenshots(from source: URL) throws -> [Screenshot]
    func move(_ screenshots: [Screenshot],from source: URL, to destination: URL) throws
}
