//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 7/1/24.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText : String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }

    func addSubscribers() {
        dataService.$allCoins.sink { [weak self] coins in
            self?.allCoins = coins

        }.store(in: &cancellables)
        
        
        $searchText.combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
    }
    
    private func filterCoin(text : String, coins : [CoinModel]) ->  [CoinModel] {
        guard !text.isEmpty else{
            return coins
        }
        
        let searchQuery = text.lowercased()
        
        let filteredCoins = coins.filter {
            (coin) -> Bool in
            return coin.name.lowercased().contains(searchQuery) ||
            coin.symbol.lowercased().contains(searchQuery) ||
            coin.id.lowercased().contains(searchQuery)
        }
        return filteredCoins
    }
}
