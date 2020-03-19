//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "17885A96-0E7F-4DC3-BBBB-ABC10F5C5386"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
       
    
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give URLSession on a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //self.delegate?.didFailWithError(error: error!)
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                       let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoin(price: priceString, currency: currency)
                    }
                }
                //Отформатируем данные, которые мы получили обратно, как строку, чтобы иметь возможность распечатать их
                /*let dataString = String(data: data!, encoding: .utf8)
                print(dataString!)*/
                
            }
            
            //4. Start the task
            task.resume()
        }
        
        
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            //print(error)
            return nil
        }
    }
    
    
    
}
