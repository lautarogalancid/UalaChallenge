//
//  CityInformationView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import SwiftUI

struct CityInformationView: View {
    let location: LocationDomainModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)

            Text("Country: \(location.country)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Coordinates:")
                .font(.headline)

            Text("Latitude: \(location.latitude)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("Longitude: \(location.longitude)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
    }
}
