//
//  NetworkEngineMock.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import Foundation

public class NetworkEngineMock: NetworkEngine {
    
    public let companies = ["MSFT", "GOOG", "AAPL", "AMZN", "INTC"]
    
    public func getStocks(company: String, completion: @escaping (Result<Bool>) -> ()) {
        
        let payload = JSONPayload.msft
        let response = DataResponseStub(payload: payload)
        
        guard let _ = response.jsonObject else {
            completion(Result.error(nil))
            return
        }
        
        completion(Result.success(true))
    }
}

extension NetworkEngineMock {
    public func emptySuccess(stocks: Bool, completion: @escaping (Result<Bool>) -> ()) {
        completion(Result.success(nil))
    }
    
    public func emptyError(stocks: Bool, completion: @escaping (Result<Error>) -> ()) {
        completion(Result.error(nil))
    }
}
