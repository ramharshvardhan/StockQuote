//
//  AlphaStocksTests.swift
//  AlphaStocksTests
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import XCTest
@testable import AlphaStocks

class AlphaStocksTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStocksQuoteFetch() {
        StocksQuote.fetchStocksQuote(company: "INTC") { (success, stocksContent) in
            XCTAssertTrue(success)
            XCTAssertTrue(stocksContent != nil)
        }
    }
    
    func testCompaniesToFetch() {
        let mainVC = ViewController()
        XCTAssertTrue(mainVC.companies.count > 0)
    }
    
    func testStocksQuoteResponse() {
        NetworkEngine.getStocksQuote(company: "MSFT") { (success, response, data, error) in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(data)
            
            if let response = response as? HTTPURLResponse {
                XCTAssertEqual(response.statusCode, 200)
            }
        }
    }
}
