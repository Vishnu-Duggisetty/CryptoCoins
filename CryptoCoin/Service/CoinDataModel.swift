//
//  CoinDataModel.swift
//  CryptoCoin
//
//  Created by Vishnu Duggisetty on 25/10/24.
//

import Foundation

enum cryptoType {
    case Token
    case Coin
}
struct Coin: Codable, Hashable {
    let name: String
    let symbol: String
    let isActive: Bool
    let type: String
    let isNew: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case isActive = "is_active"
        case type
        case isNew = "is_new"
    }
    
    var cryptoType: cryptoType {
        if type == "token" {
            return .Token
        }
        
        return .Coin
    }
}
