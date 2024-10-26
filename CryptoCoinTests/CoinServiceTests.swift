//
//  CoinServiceTests.swift
//  CryptoCoinTests
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import XCTest
@testable import CryptoCoin

class CoinServiceTests: XCTestCase {
    var coinService: CoinService!
    var mockNetworkService: MockNetworkService!
    var bundle = Bundle(for: CoinServiceTests.self)
    var mockJsonPath: String?
    var mockJson: Data?
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        coinService = CoinService(networkService: mockNetworkService)
        guard let pathURL = bundle.path(forResource: "MockCoins", ofType: "json") else {
            XCTFail("MockCoins json file is not found in bundle path: \(bundle.bundlePath)")
            return
        }
        mockJsonPath = pathURL
    }
    
    func testFetchCoinsSuccess() async throws {
        
        guard let filePath = mockJsonPath,
              let mockJson = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            XCTFail("Data not found")
            return
        }
        
        mockNetworkService.mockData = mockJson
        let coins = try await coinService.fetchCoins()
        XCTAssertEqual(coins.isEmpty, false)
    }
    
    func testFetchCoinsInvalidURL() async {
        coinService = CoinService(networkService: mockNetworkService, urlString: nil)
        do {
            _ = try await coinService.fetchCoins()
            XCTFail("Expected invalid URL error but none was thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error.errorDescription, "The URL provided was invalid.")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

