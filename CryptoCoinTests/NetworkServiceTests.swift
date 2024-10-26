//
//  NetworkServiceTests.swift
//  CryptoCoinTests
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import XCTest
@testable import CryptoCoin

class NetworkServiceTests: XCTestCase {
    var networkService: MockNetworkService!
    var validURL: URL!
    
    override func setUp() {
        super.setUp()
        networkService = MockNetworkService()
        validURL = URL(string: "https://mockurl.com")!
    }
    
    func testSuccessfulDataFetch() async throws {
        let mockJson = """
        [{"name": "Bitcoin", "symbol": "BTC", "is_active": true, "type": "coin", "is_new": false}]
        """
        networkService.mockData = mockJson.data(using: .utf8)
        
        let result: [Coin] = try await networkService.fetch(url: validURL, useCache: true)
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Bitcoin")
    }
    
    func testNetworkError() async {
        networkService.mockError = .networkError("Server is unreachable")
        
        do {
            _ = try await networkService.fetch(url: validURL, useCache: true) as [Coin]
            XCTFail("Expected to throw, but no error was thrown")
        } catch let error as NetworkError {
            XCTAssertEqual(error.errorDescription, "Network error: Server is unreachable")
        } catch {
            XCTFail("Unexpected error thrown: \(error)")
        }
    }
}
