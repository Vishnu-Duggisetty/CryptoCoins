//
//  CoinService.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

class CoinService {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCoins() async throws -> [Coin] {
        guard let url = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/") else {
            throw NetworkError.invalidUrl
        }
        
        let coins: [Coin] = try await networkService.fetch(url: url, useCache: true)
        return coins
    }
}

