//
//  LocationsPortraitView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import SwiftUI
import MapKit

struct LocationsPortraitView<ViewModel: LocationsViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLocationID: Int?

    var body: some View {
        NavigationStack {
            LocationsListView(
                locations: viewModel.filteredLocations,
                searchText: $viewModel.searchText,
                selectedLocationID: $selectedLocationID,
                onFavoriteToggled: { id in
                    viewModel.toggleFavorite(for: id)
                }
            )
            .navigationTitle("Locations")
            .navigationDestination(for: Int.self) { id in
                if let location = viewModel.filteredLocations.first(where: { $0.id == id }) {
                    LocationMapView(coordinate: .constant(
                        CLLocationCoordinate2D(
                            latitude: location.latitude,
                            longitude: location.longitude
                        )
                    ))
                    .navigationTitle(location.name)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}
