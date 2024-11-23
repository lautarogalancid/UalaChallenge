//
//  LocationsViewModel.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import Foundation
import Combine

@MainActor
protocol LocationsViewModelProtocol: ObservableObject {
    var filteredLocations: [LocationDomainModel] { get }
    var errorMessage: String? { get set }
    var selectedLocationID: Int? { get set }
    var searchText: String { get set }
    func loadLocations() async
    func toggleFavorite(for id: Int)
}

@MainActor
class LocationsViewModel: LocationsViewModelProtocol {
    private let locationService: LocationServiceProtocol
    private let favoritesService: FavoritesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var filteredLocations: [LocationDomainModel] = []
    @Published var errorMessage: String?
    @Published var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }
    @Published var selectedLocationID: Int?

    private var locations: [LocationDomainModel] = []

    init(locationService: LocationServiceProtocol, favoritesService: FavoritesServiceProtocol) {
        self.locationService = locationService
        self.favoritesService = favoritesService

        setupSearchDebounce()
    }

    func loadLocations() async {
        do {
            let loadedLocations = try await Task.detached { () -> [LocationDomainModel] in
                let fetchedLocations = try await self.locationService.fetchLocations()
                return fetchedLocations
            }.value

            let sortedLocations = try await Task.detached { () -> [LocationDomainModel] in
                return loadedLocations.sorted { lhs, rhs in
                    if lhs.name == rhs.name {
                        return lhs.country < rhs.country
                    }
                    return lhs.name < rhs.name
                }
            }.value

            await MainActor.run {
                self.locations = sortedLocations
                self.filteredLocations = sortedLocations
            }

            await loadFavorites()
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
            await filterLocations()
        }
    }

    private func loadFavorites() async {
        let favoriteIDs = favoritesService.loadFavorites()
        await MainActor.run {
            for id in favoriteIDs {
                if let index = locations.firstIndex(where: { $0.id == id }) {
                    locations[index].isFavorite = true
                }
            }
        }
        await filterLocations()
    }

    private func saveFavorites() {
        let favoriteIDs = locations.filter { $0.isFavorite }.map { $0.id }
        favoritesService.saveFavorites(favoriteIDs)
    }

    private func filterLocations() async {
        let searchTextLowercased = searchText.lowercased()

        let filtered = await Task.detached { [locations] in
            return locations.filter { location in
                searchTextLowercased.isEmpty || location.name.lowercased().hasPrefix(searchTextLowercased)
            }
        }.value

        await MainActor.run {
            self.filteredLocations = filtered
        }
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.filterLocations()
                }
            }
            .store(in: &cancellables)
    }

    private func debounceSearch() {
        setupSearchDebounce()
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
