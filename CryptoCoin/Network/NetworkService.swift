//
//  NetworkService.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case noData
    case networkError(String)
    case invalidUrl
    
    var errorDescription: String {
        switch self {
        case .invalidUrl:
            return "The URL provided was invalid."
        case .decodingError:
            return "Failed to decode the data."
        case .noData:
            return "No data was received from the server."
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

// Define a protocol to make NetworkService testable
protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL, useCache: Bool) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let cache = URLCache.shared
    
    func fetch<T: Decodable>(url: URL, useCache: Bool = true) async throws -> T {
        var request = URLRequest(url: url)
        request.cachePolicy = useCache ? .returnCacheDataElseLoad : .reloadIgnoringLocalCacheData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard response is HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            // Cache response for offline support
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
            return decodedData
        } catch _ as DecodingError {
            throw NetworkError.decodingError
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
}
