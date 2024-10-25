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
        return loadMockCoins()
        guard let url = URL(string: "https://37656be98b8f42ae8348e4da3ee3193f.api.mockbin.io/") else {
            throw NetworkError.invalidUrl
        }
        
        let coins: [Coin] = try await networkService.fetch(url: url, useCache: true)
        return coins
    }
    
    private func loadMockCoins() -> [Coin] {
        guard let path = Bundle.main.path(forResource: "MockCoins", ofType: "json") else {
            print("MockCoins.json file not found")
            return []
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decodedData = try JSONDecoder().decode([Coin].self, from: data)
            return decodedData
        } catch {
            print("Error loading mock data: \(error.localizedDescription)")
            return []
        }
    }
}

