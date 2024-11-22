//
//  AppCoordinator.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import SwiftUI

@MainActor
protocol CoordinatorProtocol {
    func start() -> AnyView
}

@MainActor
class AppCoordinator: CoordinatorProtocol {
    func start() -> AnyView {
        let locationService = LocationService()
        let viewModel = LocationsViewModel(locationService: locationService,
                                           favoritesService: FavoritesService())
        return AnyView(LocationsView(viewModel: viewModel))
    }
}
