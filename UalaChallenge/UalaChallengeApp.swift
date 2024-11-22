//
//  UalaChallengeApp.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import SwiftUI

@main
struct UalaChallengeApp: App {
    private let coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
