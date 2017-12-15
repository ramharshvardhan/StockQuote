//
//  DataResponseStub.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T?)
    case error(Error?)
}

enum JSONPayload: String {
    case msft = "MockData_MSFT"
    case intc = "MockData_INTC"
    
    var kind: String {
        return "json"
    }
}

class DataResponseStub: DataResponse {
    var objectAsJSON: Any?
    var arrayResponseStub: [Any]? {
        return objectAsJSON as? [Any]
    }
    
    var dictionaryResponseStub: [String : Any]? {
        return arrayResponseStub?.first as? [String : Any]
    }
    
    init(payload: JSONPayload) {
        super.init(jsonObject: objectAsJSON as? Data)
        guard let path = Bundle(for: type(of: self)).url(forResource: payload.stringValue, withExtension: payload.kind) else {
            return
        }
        
        do {
            let json = try Data(contentsOf: path)
            objectAsJSON = try JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions())
        } catch {
            print("\(#function) - failure parsing json content.")
        }
    }
    
    convenience init() {
        self.init(payload: .msft)
    }
}

public extension RawRepresentable where RawValue == String {
    var stringValue: String {
        return rawValue
    }
}

public extension RawRepresentable where RawValue == Double {
    var doubleValue: Double {
        return rawValue
    }
}
