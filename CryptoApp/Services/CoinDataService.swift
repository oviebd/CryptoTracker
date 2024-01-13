//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 7/1/24.
//

import Combine
import Foundation

class CoinDataService {
    @Published var allCoins: [CoinModel] = []

    var coinSubscription: AnyCancellable?

    init() {
        getCoins()
    }

    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=true&price_change_percentage=24h") else {
            return
        }

        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletation, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.coinSubscription?.cancel()
            })
    }
}
