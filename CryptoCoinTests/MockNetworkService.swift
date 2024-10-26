//
//  MockNetworkService.swift
//  CryptoCoinTests
//
//  Created by Vishnu Duggisetty on 26/10/24.
//

import XCTest
@testable import CryptoCoin

class MockNetworkService: NetworkServiceProtocol {
    var mockData: Data?
    var mockError: NetworkError?
    
    func fetch<T: Decodable>(url: URL, useCache: Bool) async throws -> T {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData else {
            throw NetworkError.noData
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}

