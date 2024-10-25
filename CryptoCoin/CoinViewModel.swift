//
//  CoinViewModel.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

class CoinViewModel {
    private let coinService: CoinService
    private(set) var allCoins: [Coin] = []
    var filteredCoins: [Coin] = []
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    
    init(coinService: CoinService = CoinService()) {
        self.coinService = coinService
    }
    
    func loadCoins() async {
        do {
            allCoins = try await coinService.fetchCoins()
            filteredCoins = allCoins
            onUpdate?()
        } catch let error as NetworkError {
            onError?(error.errorDescription)
        } catch {
            onError?("Failed to load coins: \(error.localizedDescription)")
        }
    }
    
    // Filter coins based on parameters
    func filterCoins(isActive: Bool?, type: String?, isNew: Bool?) {
        filteredCoins = allCoins
        if let isActive = isActive {
            filteredCoins = filteredCoins.filter { $0.isActive == isActive }
        }
        if let type = type {
            filteredCoins = filteredCoins.filter { $0.type == type }
        }
        if let isNew = isNew {
            filteredCoins = filteredCoins.filter { $0.isNew == isNew }
        }
        onUpdate?()
    }
    
    // Search coins based on name or symbol
    func searchCoins(searchText: String) {
        guard !searchText.isEmpty else {
            filteredCoins = allCoins
            onUpdate?()
            return
        }
        filteredCoins = allCoins.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.symbol.lowercased().contains(searchText.lowercased())
        }
        onUpdate?()
    }
}

