//
//  LocationsListView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import SwiftUI
import MapKit

struct LocationsListView: View {
    let locations: [LocationDomainModel]
    @Binding var searchText: String
    @Binding var selectedLocationID: Int?
    let onFavoriteToggled: (Int) -> Void

    @State private var showCityInfo: Bool = false
    @State private var selectedCity: LocationDomainModel?

    var body: some View {
        VStack {
            TextField("Search cities...", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding([.leading, .trailing])

            List(locations, id: \.id) { location in
                NavigationLink(
                    value: location.id,
                    label: {
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
                                onFavoriteToggled(location.id)
                            }) {
                                Image(systemName: location.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(location.isFavorite ? .yellow : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Button(action: {
                                selectedCity = location
                                showCityInfo.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                )
                .contentShape(Rectangle())
            }
            .sheet(isPresented: $showCityInfo) {
                if let city = selectedCity {
                    CityInformationView(location: city)
                        .presentationDetents([.fraction(0.3), .height(200)])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}
