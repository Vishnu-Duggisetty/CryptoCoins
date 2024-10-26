//
//  CoinService.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

class CoinService {
    private let networkService: NetworkServiceProtocol
    private let urlString: String?
    
    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        urlString: String? = "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/"
    ) {
        self.networkService = networkService
        self.urlString = urlString
    }
    
    func fetchCoins() async throws -> [Coin] {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            throw NetworkError.invalidUrl
        }
        
        let coins: [Coin] = try await networkService.fetch(url: url, useCache: true)
        return coins
    }
}

