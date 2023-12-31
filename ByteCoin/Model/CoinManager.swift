

import Foundation

protocol CoinManagerDelegate {
    func didUpdate(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "2B323B79-9EFE-412B-BD56-A898F41E959E"

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
          
          let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"

          if let url = URL(string: urlString) {
              
              let session = URLSession(configuration: .default)
              let task = session.dataTask(with: url) { (data, response, error) in
                  if error != nil {
                      print(error!)
                      return
                  }
                  
                  if let safeData = data {
                      print("safeData is = ",safeData)
                       if let bitcoinPrice = self.parseJSON(safeData){
                          let priceString = String(format: "%.2f", bitcoinPrice)
                          self.delegate?.didUpdate(price: priceString, currency: currency)
                      }
                  }
              }
              task.resume()
          }
      }
      
      func parseJSON(_ data: Data) -> Double? {
          
          //Create a JSONDecoder
          let decoder = JSONDecoder()
          do {
              
              //try to decode the data using the CoinData structure
              let decodedData = try decoder.decode(CoinData.self, from: data)
              
              //Get the last property from the decoded data.
              let lastPrice = decodedData.rate
              print(lastPrice)
              return lastPrice
              
          } catch {
              
              print(error)
              return nil
          }
      }
    
}
