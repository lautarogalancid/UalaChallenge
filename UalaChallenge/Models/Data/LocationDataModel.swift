//
//  LocationDataModel.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 21/11/2024.
//

struct LocationDataModel: Decodable {
    let id: Int
    let name: String
    let country: String
    let coord: Coordinate

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case country
        case coord
    }
}

struct Coordinate: Decodable {
    let lon: Double
    let lat: Double
}

extension LocationDataModel {
    func toDomain() -> LocationDomainModel {
        LocationDomainModel(
            id: id,
            name: name,
            country: country,
            latitude: coord.lat,
            longitude: coord.lon
        )
    }
}
