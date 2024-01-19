//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 14/1/24.
//

import Combine
import Foundation

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
            return
        }

        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletation, receiveValue: { [weak self] globarData in
                self?.marketData = globarData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
