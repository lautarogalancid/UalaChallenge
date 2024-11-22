//
//  LocationMapView.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @Binding var coordinate: CLLocationCoordinate2D?

    var body: some View {
        Map {
            if let coordinate = coordinate {
                Annotation("", coordinate: coordinate) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .mapControlVisibility(.automatic)
    }
}
