//
//  DataResponse.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

// A simple JSON object parser

import Foundation

public class DataResponse: NSObject {
    
    public enum ResponseType: Int {
        case array
        case dictionary
        case blob
    }
    
    var kind: ResponseType? = .dictionary
    var arrayResponse: [String]?
    var dictionaryResponse: [String: Any]?
    var blobResponse: Data?
    var jsonObject: Any?
    
    init(jsonObject: Data?) {
        self.jsonObject = jsonObject
    }
    
    public func dictionaryResponse(dictionary: [String: Any]) -> DataResponse {
        let response = self
        response.kind = ResponseType.dictionary
        response.dictionaryResponse = dictionary
        return response
    }
    
    public func arrayResponse(array: [String]) -> DataResponse {
        let response = self
        response.kind = ResponseType.array
        response.arrayResponse = array
        return response
    }
    
    public func blobResponse(data: Data) -> DataResponse {
        let response = self
        response.kind = ResponseType.blob
        response.blobResponse = data
        return response
    }
    
    public func response(data: Data) -> DataResponse {
        
        let response = self
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print("\(#function) - failure parsing json content.")
        }
        
        if jsonObject is Dictionary<String, Any> {
            response.kind = ResponseType.dictionary
            response.dictionaryResponse = jsonObject as? Dictionary
        } else if jsonObject is Array<String> {
            response.kind = ResponseType.array
            response.arrayResponse = jsonObject as? Array
        } else {
            response.kind = ResponseType.blob
        }
        
        return response
    }
}

