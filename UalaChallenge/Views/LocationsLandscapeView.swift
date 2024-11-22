//
//  LocationsLandscapeView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import SwiftUI
import MapKit

struct LocationsLandscapeView<ViewModel: LocationsViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var selectedLocationID: Int?
    @State private var showInformationSheet = false
    @State private var selectedLocationForInfo: LocationDomainModel?

    var body: some View {
        HStack {
            VStack {
                TextField("Search cities...", text: $viewModel.searchText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding([.leading, .trailing])

                List(viewModel.filteredLocations, id: \.id) { location in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(location.name), \(location.country)")
                                .font(.headline)
                            Text("Lat: \(location.latitude), Lon: \(location.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Button(action: {
                            viewModel.toggleFavorite(for: location.id)
                        }) {
                            Image(systemName: location.isFavorite ? "star.fill" : "star")
                                .foregroundColor(location.isFavorite ? .yellow : .gray)
                        }
                        .buttonStyle(BorderlessButtonStyle())

                        Button(action: {
                            selectedLocationForInfo = location
                            showInformationSheet = true
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLocationID = location.id
                    }
                }
            }
            .frame(maxWidth: .infinity)

            if let selectedLocationID = selectedLocationID,
               let selectedLocation = viewModel.filteredLocations.first(where: { $0.id == selectedLocationID }) {
                LocationMapView(coordinate: .constant(
                    CLLocationCoordinate2D(
                        latitude: selectedLocation.latitude,
                        longitude: selectedLocation.longitude
                    )
                ))
                .frame(maxWidth: .infinity)
            } else {
                Text("Select a location to view it on the map")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.1))
            }
        }
        .sheet(isPresented: $showInformationSheet) {
            if let location = selectedLocationForInfo {
                CityInformationView(location: location)
                    .presentationDetents([.medium, .fraction(0.5)])
                    .padding(.top, 10)
            }
        }
    }
}
