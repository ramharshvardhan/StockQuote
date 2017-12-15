//
//  NetworkEngine.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

// A managing engine for Network call requests

import Foundation

public class NetworkEngine: NSObject {
    
    // MARK: - CALLBACKS
    public typealias DataResponseCallback = (_ success: Bool, _ response: URLResponse?, _ data: DataResponse?, _ error: Error?) -> ()
    
    // MARK: - PRIVATE PROPERTIES
    fileprivate static let defaultSession = URLSession(configuration: .default)
    fileprivate static var dataTask: URLSessionDataTask?
    fileprivate static let stocksURLPath = "https://www.alphavantage.co/query" //Alpha Vantage API
    fileprivate static let apiAccessKey = "7PUGEF8HFCP4TP47"
    
    // MARK: - PUBLIC METHODS
    public static func getStocksQuote(company: String, completion: @escaping DataResponseCallback) {
        
        dataTask?.cancel()
        
        var dataResponse: DataResponse? = nil
        
        if var urlComponents = URLComponents(string: NetworkEngine.stocksURLPath) {
            urlComponents.query = "function=TIME_SERIES_DAILY&symbol=\(company)&apikey=\(apiAccessKey)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    completion(false, nil, nil, error)
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    let jsonObject = DataResponse(jsonObject: data)
                    dataResponse = jsonObject.response(data: data)
                    
                    DispatchQueue.main.async {
                        if let dataResponse = dataResponse {
                            completion(true, response, dataResponse, nil)
                        }
                    }
                }
            }
            dataTask?.resume()
        }
    }
}

