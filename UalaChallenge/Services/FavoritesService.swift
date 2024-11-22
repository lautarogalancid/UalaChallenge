//
//  FavoritesService.swift
//  UalaChallenge
//
//  Created by Lautaro Emanuel Galan Cid on 22/11/2024.
//

import Foundation

protocol FavoritesServiceProtocol {
    func loadFavorites() -> [Int]
    func saveFavorites(_ favoriteIDs: [Int])
}

class FavoritesService: FavoritesServiceProtocol {
    private let favoritesKey = "FavoriteCities"

    func loadFavorites() -> [Int] {
        UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
    }

    func saveFavorites(_ favoriteIDs: [Int]) {
        UserDefaults.standard.set(favoriteIDs, forKey: favoritesKey)
    }
}
