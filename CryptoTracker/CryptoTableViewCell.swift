
import UIKit

class CryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyPrice: UILabel!
    
    func formatCell(withCurrencyType currencyType: CurrencyType) {
        currencyName.text = currencyType.symbol
        self.currencyPrice.text = currencyType.price + "$" + " (" + currencyType.change + "%)"
        if (currencyType.status == "green") {
            self.currencyPrice.textColor = UIColor.systemGreen
        } else {
            self.currencyPrice.textColor = UIColor.red
        }

        
        guard let url = URL(string: currencyType.imageUrl) else {
                    print("Invalid URL")
                    return
                }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in

                    guard let data = data, error == nil else { return }
                    DispatchQueue.main.async {
                        self.currencyImageView.image = UIImage(data: data)
                        
                    }
                }.resume()

        
    }

}


