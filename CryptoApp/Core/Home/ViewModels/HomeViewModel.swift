//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 7/1/24.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var statistics: [Statistic] = [
        Statistic(title: "Title 1", value: "Value", percentageChange: 1),
        Statistic(title: "Title 2", value: "Value 2"),
        Statistic(title: "Title 3", value: "Value 3"),
        Statistic(title: "Title 4", value: "Value4", percentageChange: -10),
    ]

    @Published var allCoins: [CoinModel] = []

    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""

    @Published var isLoading : Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()

    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscribers()
    }

    func addSubscribers() {
        $searchText.combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] filteredCoins in
                if filteredCoins.count > 0 {
                    self?.allCoins = filteredCoins
                } else {
                    self?.allCoins = [DeveloperPreview.instance.coin]
                }
            }
            .store(in: &cancellables)

        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)

            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }.store(in: &cancellables)

        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.statistics = stats
                self?.isLoading = false
            }.store(in: &cancellables)
    }

    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }

    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        
        HapticManager.notifications(type: .success)
    }
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }

        let searchQuery = text.lowercased()

        let filteredCoins = coins.filter {
            coin -> Bool in
            coin.name.lowercased().contains(searchQuery) ||
                coin.symbol.lowercased().contains(searchQuery) ||
                coin.id.lowercased().contains(searchQuery)
        }
        return filteredCoins
    }

    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        allCoins.compactMap { coin -> CoinModel? in
            guard let entity = portfolioEntities.first(where: { $0.coinId == coin.id
            }) else {
                return nil
            }
            return coin.updateHoldings(amount: entity.amount)
        }
    }

    private func mapGlobalMarketData(marketData: MarketDataModel?, portfolioCoins: [CoinModel]) -> [Statistic] {
        var stats = [Statistic]()

        guard let data = marketData else {
            return stats
        }

        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)

        let volume = Statistic(title: "24h Volume", value: data.volume)

        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)

        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)

        // Math Calculation
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
            let previousValue = currentValue / (1 + percentageChange)
            return previousValue
        }.reduce(0, +)

        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100

        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)

        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio,
        ])

        return stats
    }
}
