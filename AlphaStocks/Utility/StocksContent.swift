//
//  StocksContent.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

// A struct that confirms to protocol `Codable` that takes a dict payload and returns
// parsed object

import Foundation

public struct StocksContent: Codable {
    let lowPrice: String
    let highPrice: String
    let openingPrice: String
    let closingPrice: String
    let volume: String
    
    var company: String = ""
    
    public init(_ payload: [String: Any]) {
        self.openingPrice = payload["1. open"] as? String ?? ""
        self.highPrice = payload["2. high"] as? String ?? ""
        self.lowPrice = payload["3. low"] as? String ?? ""
        self.closingPrice = payload["4. close"] as? String ?? ""
        self.volume = payload["5. volume"] as? String ?? ""
    }
}
