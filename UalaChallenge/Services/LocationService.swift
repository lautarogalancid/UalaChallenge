//
//  LocationService.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

import Foundation

protocol LocationServiceProtocol {
    func fetchLocations() async throws -> [LocationDomainModel]
}

class LocationService: LocationServiceProtocol {
    func fetchLocations() async throws -> [LocationDomainModel] {
        guard let url = URL(string: "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let locationsData = try JSONDecoder().decode([LocationDataModel].self, from: data)
        return locationsData.map { $0.toDomain() }
    }
}
