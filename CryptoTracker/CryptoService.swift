//
//  CryptoService.swift
//  CryptoTracker
//
//  Created by Oleg Merkuriev on 12.03.2023.
//  Copyright © 2023 Maxwell Stein. All rights reserved.
//

import Foundation

class Symbol {
    init(symbol: String, price: String, change: String, status: String, nameFull: String, image: String) {
        self.symbol = symbol;
        self.price = price;
        self.change = change;
        self.status = status;
        self.nameFull = nameFull;
        self.imageUrl = image;
    }
    let symbol: String
    let price: String
    let change: String
    let status: String
    let nameFull: String
    let imageUrl: String
}

final class CryptoService {
    func fetchSymbols(completion: @escaping ([Symbol]?, Error?) -> Void) {
        // Define the API endpoint URL
        let endpoint = "http://localhost:3000/crypto/markets?quote=USDT"

        // Create a URL object from the endpoint string
        guard let url = URL(string: endpoint) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        // Create a URLSession object to perform the API request
        let session = URLSession.shared

        // Create a data task to fetch the data from the API
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            // Check for errors
            if let error = error {
                completion(nil, error)
                return
            }

            // Check for a valid response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(nil, NSError(domain: "Invalid response", code: 0, userInfo: nil))
                return
            }

            // Check that we received data
            guard let data = data else {
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }

            do {
                // Parse the JSON data into a dictionary
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                // Extract the list of symbols from the dictionary
                if let symbols = json?["symbols"] as? [[String: Any]] {
                    var symbolArray = [Symbol]()
                    for symbol in symbols {
                        if let symbolValue = symbol["symbol"] as? String,
                           let priceValue = symbol["price"] as? String,
                           let change = symbol["change"] as? String,
                           let status = symbol["status"] as? String,
                            let nameFull = symbol["nameFull"] as? String,
                        let image = symbol["image"] as? String {
                            let newSymbol = Symbol(symbol: symbolValue, price: priceValue, change: change, status: status, nameFull: nameFull, image: image)
                            symbolArray.append(newSymbol)
                        }
                    }
                    completion(symbolArray, nil)
                }
            } catch {
                completion(nil, error)
            }
        })

        // Start the data task to fetch the data from the API
        task.resume()
    }
}
