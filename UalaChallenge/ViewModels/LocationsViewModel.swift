//
//  LocationsViewModel.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import Foundation

@MainActor
protocol LocationsViewModelProtocol: ObservableObject {
    var filteredLocations: [LocationDomainModel] { get }
    var errorMessage: String? { get set }
    var selectedLocationID: Int? { get set }
    var searchText: String { get set }
    func loadLocations() async
    func toggleFavorite(for id: Int)
    // TODO: Agregar lista de favoritos
}

@MainActor
class LocationsViewModel: LocationsViewModelProtocol {
    private let locationService: LocationServiceProtocol
    private let favoritesService: FavoritesServiceProtocol

    @Published private(set) var filteredLocations: [LocationDomainModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = "" {
        didSet {
            filterLocations()
        }
    }
    @Published var selectedLocationID: Int?

    private var locations: [LocationDomainModel] = []

    init(locationService: LocationServiceProtocol, favoritesService: FavoritesServiceProtocol) {
        self.locationService = locationService
        self.favoritesService = favoritesService
    }

    func loadLocations() async {
        do {
            let loadedLocations = try await locationService.fetchLocations()
            let sortedLocations = sortLocations(loadedLocations)
            await MainActor.run {
                self.locations = sortedLocations
                self.filteredLocations = sortedLocations
            }
            loadFavorites()
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func toggleFavorite(for id: Int) {
        guard let index = locations.firstIndex(where: { $0.id == id }) else {
            return
        }

        Task { @MainActor in
            locations[index].isFavorite.toggle()
            saveFavorites()
            filterLocations()
        }
    }

    private func loadFavorites() {
        let favoriteIDs = favoritesService.loadFavorites()
        Task { @MainActor in
            for id in favoriteIDs {
                if let index = locations.firstIndex(where: { $0.id == id }) {
                    locations[index].isFavorite = true
                }
            }
            filterLocations()
        }
    }

    private func saveFavorites() {
        let favoriteIDs = locations.filter { $0.isFavorite }.map { $0.id }
        favoritesService.saveFavorites(favoriteIDs)
    }

    private func filterLocations() {
        DispatchQueue.global(qos: .userInitiated).async {
            // TODO: Ver lag de UI aca
            let filtered = self.locations.filter { location in
                self.searchText.isEmpty || location.name.lowercased().hasPrefix(self.searchText.lowercased())
            }
            DispatchQueue.main.async {
                self.filteredLocations = filtered
            }
        }
    }

    private func sortLocations(_ locations: [LocationDomainModel]) -> [LocationDomainModel] {
        return locations.sorted { lhs, rhs in
            if lhs.name == rhs.name {
                return lhs.country < rhs.country
            }
            return lhs.name < rhs.name
        }
    }
}
