//
//  CoinDetailsService.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 19/1/24.
//

import Combine
import Foundation

class CoinDetailsService  {
    
    @Published var coinDetails: CoinDetailsModel? = nil

    
    var coinDetailsSubscription: AnyCancellable?
    let coin : CoinModel
    
    init(coin : CoinModel) {
        self.coin = coin
        getCoins()
    }

    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
            return
        }

        coinDetailsSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailsModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletation, receiveValue: { [weak self] details in
                self?.coinDetails = details
                self?.coinDetailsSubscription?.cancel()
            })
    }
}

