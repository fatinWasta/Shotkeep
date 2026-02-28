//
//  NavigationCoordinator.swift
//  ShotKeep
//
//  Created by Fatin on 28/02/26.
//

import Combine
import SwiftUI

final class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
}
