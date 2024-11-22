//
//  LocationsView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//


import SwiftUI
import MapKit

struct LocationsView<ViewModel: LocationsViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var selectedLocationID: Int?

    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                LocationsLandscapeView(
                    viewModel: viewModel,
                    selectedLocationID: $selectedLocationID
                )
            } else {
                LocationsPortraitView(
                    viewModel: viewModel,
                    selectedLocationID: $selectedLocationID
                )
            }
        }
        .onAppear {
            Task {
                await viewModel.loadLocations()
            }
        }
    }
}


// MARK: - Mocks & Preview

#Preview {
    let mockService = MockLocationService()
    let viewModel = MockLocationsViewModel(locationService: mockService)
    LocationsView(viewModel: viewModel)
}

class MockLocationService: LocationServiceProtocol {
    func fetchLocations() async throws -> [LocationDomainModel] {
        return [
            LocationDomainModel(id: 1, name: "Cordoba", country: "CBA", latitude: 123.0, longitude: 123.0),
            LocationDomainModel(id: 2, name: "BsAs", country: "BAS", latitude: 123.0, longitude: 1234.0),
            LocationDomainModel(id: 3, name: "Sta Fe", country: "SFE", latitude: 1234.0, longitude: 3430.0)
        ]
    }
}

class MockLocationsViewModel: LocationsViewModelProtocol {
    var filteredLocations: [LocationDomainModel] = []
    
    var searchText: String = ""
    
    func loadFavorites() {
        //
    }
    
    func saveFavorites() {
        //
    }
    
    func filterLocations(with text: String) {
        //
    }
    
    @Published var locations: [LocationDomainModel] = []
    @Published var errorMessage: String?
    @Published var selectedLocationID: Int?

    var selectedLocation: LocationDomainModel? {
        locations.first(where: { $0.id == selectedLocationID })
    }

    private let locationService: LocationServiceProtocol

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }

    func loadLocations() async {
        do {
            locations = try await locationService.fetchLocations()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFavorite(for id: Int) {
        if let index = locations.firstIndex(where: { $0.id == id }) {
            locations[index].isFavorite.toggle()
        }
    }
}
