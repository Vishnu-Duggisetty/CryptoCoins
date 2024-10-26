//
//  CoinViewModelTests.swift
//  CryptoCoinTests
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import XCTest
@testable import CryptoCoin

class CoinViewModelTests: XCTestCase {
    var viewModel: CoinViewModel!
    var mockCoinService: CoinService!
    
    override func setUp() {
        super.setUp()
        let mockNetworkService = MockNetworkService()
        mockNetworkService.mockData = """
        [{"name": "Bitcoin", "symbol": "BTC", "is_active": true, "type": "coin", "is_new": false},
         {"name": "Ethereum", "symbol": "ETH", "is_active": false, "type": "token", "is_new": true}]
        """.data(using: .utf8)
        
        mockCoinService = CoinService(networkService: mockNetworkService)
        viewModel = CoinViewModel(coinService: mockCoinService)
    }
    
    func testLoadCoins() async {
        let expectation = XCTestExpectation(description: "Coins loaded")
        
        viewModel.onUpdate = {
            XCTAssertEqual(self.viewModel.allCoins.count, 2)
            expectation.fulfill()
        }

        await viewModel.loadCoins()
        
        // Using await fulfillment is especially helpful in asynchronous tests for reliable, predictable execution.
        await fulfillment(of: [expectation], timeout: 2)
    }
    
    func testSearchCoins() {
        viewModel.allCoins = [
            Coin(name: "Bitcoin", symbol: "BTC", isActive: true, type: "coin", isNew: false),
            Coin(name: "Ethereum", symbol: "ETH", isActive: true, type: "token", isNew: true)
        ]
        viewModel.searchCoins(searchText: "BTC")
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.symbol, "BTC")
    }
    
    func testFilterCoinsByActiveStatus() {
        viewModel.allCoins = [
            Coin(name: "Bitcoin", symbol: "BTC", isActive: true, type: "coin", isNew: false),
            Coin(name: "Ethereum", symbol: "ETH", isActive: false, type: "token", isNew: true)
        ]
        viewModel.filterCoins(isActive: true, inActive: nil, type: nil, isNew: nil)
        XCTAssertEqual(viewModel.filteredCoins.count, 1)
        XCTAssertEqual(viewModel.filteredCoins.first?.name, "Bitcoin")
    }
    
    func testRemoveFilters() {
        viewModel.allCoins = [
            Coin(name: "Bitcoin", symbol: "BTC", isActive: true, type: "coin", isNew: false),
            Coin(name: "Ethereum", symbol: "ETH", isActive: false, type: "token", isNew: true)
        ]
        viewModel.filteredCoins = [viewModel.allCoins[0]]
        viewModel.removeFilters()
        XCTAssertEqual(viewModel.filteredCoins.count, viewModel.allCoins.count)
    }
}
