//
//  StocksQuote.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import Foundation

class StocksQuote: NSObject {
    
    // MARK: - CALLBACKS
    typealias StocksResponseCallback = (_ success: Bool, _ content: StocksContent?) -> ()
    
    // MARK: - PUBLIC METHODS
    public static func fetchStocksQuote(company: String, _ callback: @escaping StocksResponseCallback) {
        
        NetworkEngine.getStocksQuote(company: company) { (success, response, data, error) in
            if success {
                if let data = data, let response = data.dictionaryResponse {
                    if let itemDictionary = response["Time Series (Daily)"] as? [String: Any] {
                        let todayDate = stringFromTodaysDate()
                        let yesterdayDate = stringFromYesterdaysDate()
                        let dayBeforeYesterdayDate = stringFromDayBeforeYesterdaysDate()
                        
                        //Check for today's date in Stocks response, if market is/was open today
                        if let todayStockDictionary = itemDictionary[todayDate] as? [String: Any] {
                            var todayStocksContent = StocksContent.init(todayStockDictionary)
                            todayStocksContent.company = company
                            callback(success, todayStocksContent)
                            
                        } else
                            //Looks like market wasn't open today, so check for yesterday's date
                            if let yesterdayStockDictionary = itemDictionary[yesterdayDate] as? [String: Any] {
                                var yesterdayStocksContent = StocksContent.init(yesterdayStockDictionary)
                                yesterdayStocksContent.company = company
                                callback(success, yesterdayStocksContent)
                            } else
                                //Looks like market wasn't open yesterday as well (Read "Sunday")
                                //so check for day before yesterday's date (Friday ?)
                                if let dayBeforeYesterdayStockDictionary = itemDictionary[dayBeforeYesterdayDate] as? [String: Any] {
                                    var dayBeforeYesterdayStocksContent = StocksContent.init(dayBeforeYesterdayStockDictionary)
                                    dayBeforeYesterdayStocksContent.company = company
                                    callback(success, dayBeforeYesterdayStocksContent)
                        }
                    } else {
                        //Successful callback, but couldn't find required dict.
                        callback(success, nil)
                    }
                } else {
                    //Successful callback, but no data
                    callback(success, nil)
                }
            } else {
                //Unsuccessful callback
                callback(success, nil)
            }
        }
    }
}

extension StocksQuote {
    static let stocksDateParser: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static func stringFromTodaysDate() -> String {
        let currentDate = NSDate() as Date
        return stocksDateParser.string(from: currentDate)
    }
    
    static func stringFromYesterdaysDate() -> String {
        let yesterdayDate = Date().yesterday
        return stocksDateParser.string(from: yesterdayDate)
    }
    
    static func stringFromDayBeforeYesterdaysDate() -> String {
        let dayBeforeYesterdayDate = Date().dayBeforeYesterday
        return stocksDateParser.string(from: dayBeforeYesterdayDate)
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayBeforeYesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

