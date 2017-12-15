//
//  StockDetailViewController.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit

class StockDetailViewController: UIViewController {
    
    // MARK: - IBOUTLETS
    @IBOutlet fileprivate var companyName: UILabel!
    @IBOutlet fileprivate var lowPrice: UILabel!
    @IBOutlet fileprivate var highPrice: UILabel!
    @IBOutlet fileprivate var openingPrice: UILabel!
    @IBOutlet fileprivate var closingPrice: UILabel!
    @IBOutlet fileprivate var volume: UILabel!
    
    //MARK: - PUBLIC PROPERTIES
    public var stockContent: StocksContent? = nil
    public var company = "COMPANY"
    
    //MARK: - INITIALIZERS
    public convenience init(_ content: StocksContent) {
        self.init()
        self.stockContent = content
    }
    
    //MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }
    
    fileprivate func setupView() {
        title = "STOCK DETAILS"
        navigationController?.navigationBar.tintColor = UIColor.brown
        companyName.text = company
    }
    
    fileprivate func configureView() {
        guard let content = stockContent else { return }
        
        lowPrice.text = "Low Price: \(content.lowPrice)"
        highPrice.text = "High Price: \(content.highPrice)"
        openingPrice.text = "Opening Price: \(content.openingPrice)"
        closingPrice.text = "Closing Price: \(content.closingPrice)"
        volume.text = "Volume: \(content.volume)"
    }
}

