import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var finalURL = ""
    
    let header: [String : String] = ["x-ba-key" : "N2I4MWEzMjI4N2I5NDE1OWJhODQ1OTBjMGYyM2E4MDU"]
    
    
    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        finalURL = baseURL + currencyArray[0]
        self.getBitcoinValue(url: finalURL, header: header, symbolIndex: 0)
    }
    
    
    
    // To determine how many columns we want in our picker.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // To determine how many rows this picker would be using
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    // To fill the picker row titles with Strings from currencyArray
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    // To tell the picker what to do when the user selects a particular row.
    // This method will get called everytime the picker is scrolled.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        getBitcoinValue(url: finalURL, header: header, symbolIndex: row)
    }
    

    func getBitcoinValue(url: String, header: [String : String], symbolIndex: Int) {
        
        Alamofire.request(url, method: .get, headers: header)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got the bitcoin data")
                    print(response.result.value!)
                    
                    // Parse JSON
                    let bitcoinJson : JSON = JSON(response.result.value!)
                    
                    // Update price label
                    self.bitcoinPriceLabel.text = self.currencySymbols[symbolIndex] +   bitcoinJson["ask"].stringValue
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }
    }
}

