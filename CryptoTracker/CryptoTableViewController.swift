

import UIKit
import WebKit

final class CryptoTableViewController: UITableViewController {
    let cryptoService: CryptoService = CryptoService();
    var currencies: [CurrencyType] = []
    var symbols: [Symbol] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = true
        fetchData()
    }


    func fetchData() {
        cryptoService.fetchSymbols { [weak self] symbols, error in
            guard let self = self else { return }
            if let symbols = symbols {
                self.symbols = symbols
                print(self.symbols)
                self.currencies = symbols.map { CurrencyType(symbol: $0.symbol, price: $0.price, change: $0.change, status: $0.status, nameFull: $0.nameFull, image: $0.imageUrl  ) }
                print(self.currencies)
                DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
            } else if let error = error {
                print(error)
            }
        }
    }
    let reuseIdentifier = String(describing: CryptoTableViewCell.self)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        if let cryptoTableViewCell = tableViewCell as? CryptoTableViewCell {
            let currencyType = currencies[indexPath.row]
            cryptoTableViewCell.formatCell(withCurrencyType: currencyType)
        }
        
        return tableViewCell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Cryptocurrency Prices"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return "Updated on " + dateString
    }


}

