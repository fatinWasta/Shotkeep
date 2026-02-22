//
//  Screenshot.swift
//  ShotKeep
//
//  Created by Fatin on 22/02/26.
//
import Foundation

struct Screenshot: Equatable, Identifiable {
    let id: UUID = UUID()
    let url: URL
    let createdAt: Date

}
