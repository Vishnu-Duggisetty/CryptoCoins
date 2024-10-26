//
//  CoinViewModel.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

class CoinViewModel {
    private let coinService: CoinService
    var allCoins: [Coin] = []
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
    
    func filterCoins(
        isActive: Bool?,
        inActive: Bool?,
        type: String?,
        isNew: Bool?
    ) {
        var coins = Set(allCoins)
        if let type = type {
            let inCoins = allCoins.filter { $0.type == type }
            coins = Set(inCoins)
        }
        
        if isNew == true {
            if coins.isEmpty {
                let inCoins = allCoins.filter { $0.isNew == true }
                coins = Set(inCoins)
            } else {
                let inCoins = coins.filter { $0.isNew == true }
                coins = Set(inCoins)
            }
        }
        
        let typeCoins = coins.isEmpty ? Set(allCoins) : coins
        if isActive == true, inActive != true {
            let inCoins = typeCoins.filter { $0.isActive == true }
            coins = Set(inCoins)
        }
        if inActive == true, isActive != true {
            let inCoins = typeCoins.filter { $0.isActive == false }
            coins = Set(inCoins)
        }
        
        filteredCoins = Array(coins)
        onUpdate?()
    }
    
    func removeFilters() {
        filteredCoins = allCoins
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

