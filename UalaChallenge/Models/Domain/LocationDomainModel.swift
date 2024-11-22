//
//  LocationDomainModel.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import Foundation

struct LocationDomainModel: Identifiable {
    let id: Int
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double
    var isFavorite: Bool = false
}
