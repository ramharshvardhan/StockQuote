//
//  ViewController.swift
//  AlphaStocks
//
//  Created by Ram Harshvardhan Radhakrishnan on 12/14/17.
//  Copyright © 2017 Ram Harshvardhan Radhakrishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOUTLETS
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var headlineLabel: UILabel!
    @IBOutlet fileprivate var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - PUBLIC PROPERTIES
    public let companies: [String] = ["MSFT", "GOOG", "AAPL", "AMZN", "INTC"]
    
    // MARK: - PRIVATE PROPERTIES
    fileprivate let cellReuseIdentifier = "stocksCell"
    fileprivate var stocksContent: [StocksContent] = []
    fileprivate var refreshControl: UIRefreshControl!
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        headlineLabel.textColor = UIColor.brown
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh() {
        fetchStocks()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        fetchStocks()
    }
    
    // MARK: - PUBLIC METHODS
    public func fetchStocks() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        for company in companies {
            StocksQuote.fetchStocksQuote(company: company) { [weak self] (success, content) in
                guard success, let stocksContentResponse = content else { return }
                guard let strongSelf = self else { return }
                
                //Check if the array already contains the response
                if !strongSelf.stocksContent.contains(where: { (stock) -> Bool in
                    if stock.company == stocksContentResponse.company {
                        return true
                    }
                    return false
                }) {
                    //Nope, it's not there. So, add it now.
                    strongSelf.stocksContent.append(stocksContentResponse)
                    strongSelf.tableView.reloadData()
                }
                strongSelf.activityIndicator.stopAnimating()
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - TABLEVIEW DELEGATE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: StocksCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! StocksCell
        
        cell.stocksImage.image = UIImage.init(named: "dollarSign")
        cell.companyName.text = companies[indexPath.row]
        cell.stocksTradingPrice.text = "0.00"
        
        // The reason to get the element based on the company name is that
        // the API we are calling only returns one object as of now, i.e. `INTC`
        // Getting a `cancelled` error code 999 (exceeded the bandwidth or something)
        // for all other companies
        let availableElements = stocksContent.flatMap({ (element) -> StocksContent? in
            return element.company == cell.companyName.text ? element : nil
        })
        
        if availableElements.count > 0 {
            // Assuming there will be only one element in the array,
            // since the company names are unique.
            guard let firstElement = availableElements.first else { return UITableViewCell() }
            
            //Applying attributes to text
            let lowPriceString = "Low: \(firstElement.lowPrice)" + " "
            let highPriceString = "High: \(firstElement.highPrice)"
            let attributedString = applyAttributes(firstString: lowPriceString, secondString: highPriceString)
            
            cell.stocksTradingPrice.attributedText = attributedString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.navigationBar.isHidden = false
        let storyboard = UIStoryboard.init(name:"Main", bundle:Bundle.main)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "StockDetailViewController") as? StockDetailViewController {
            
            detailVC.company = companies[indexPath.row]
            
            let availableElements = stocksContent.flatMap({ (element) -> StocksContent? in
                return element.company == companies[indexPath.row] ? element : nil
            })
            
            if availableElements.count > 0 {
                // Assuming there will be only one element in the array,
                // since the company names are unique.
                // Set stock content in detailVC, if we have it yet
                detailVC.stockContent = availableElements.first
            }
            
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    // MARK: - HELPER METHODS
    func applyAttributes(firstString: String, secondString: String) -> NSMutableAttributedString {
        let firstAttr: NSMutableAttributedString = NSMutableAttributedString(string: firstString)
        firstAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSMakeRange(0, firstAttr.length))
        let secondAttr: NSMutableAttributedString = NSMutableAttributedString(string:  secondString)
        secondAttr.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.green, range: NSMakeRange(0, secondAttr.length))
        firstAttr.append(secondAttr)
        
        return firstAttr
    }
}


