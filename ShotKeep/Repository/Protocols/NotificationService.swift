//
//  NotificationService.swift
//  ShotKeep
//
//  Created by Fatin on 28/02/26.
//

protocol NotificationService {
    func requestPermission()
    func show(title: String, message: String)
}
