//
//  DetailsViewModel.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 19/1/24.
//

import Foundation
import Combine

class DetailsViewModel : ObservableObject {
    
    @Published var coin : CoinModel
    private let coinDetailsDataService : CoinDetailsService
    @Published var overviewStatistics : [Statistic] = [Statistic]()
    @Published var additionalStatistics : [Statistic] = [Statistic]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailsDataService = CoinDetailsService(coin: coin)
        addSubscribers()
    }
    
    func addSubscribers(){
        coinDetailsDataService.$coinDetails
            .combineLatest($coin)
            .map({ (coinDetailsModel , coinModel) -> (overview : [Statistic], additional : [Statistic] ) in
                
            // OverView

                let currentPrice = coinModel.currentPrice.asCurrencyWith6Decimals()
                let currentPriceChange = coinModel.priceChangePercentage24H
                let currentPriceStat = Statistic(title: "Current Price", value: currentPrice, percentageChange: currentPriceChange)
                
                let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
                let marketcapChange = coinModel.marketCapChangePercentage24H
                let marketStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketcapChange)
                
                let rank = "\(coinModel.rank)"
                let ranStat = Statistic(title: "Rank", value: rank)
                
                let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
                let volumeStat = Statistic(title: "Volume", value: volume)
                
                let overViewArray: [Statistic] = [
                    currentPriceStat,marketStat,ranStat,volumeStat
                ]
                
            // Additional

            
                let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
                let highStat = Statistic(title: "24h High", value: high)
                
                let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
                let lowhStat = Statistic(title: "24h Low", value: high)
                
                let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
                let priceChangePercentage = coinModel.priceChangePercentage24H
                let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: priceChangePercentage)
                
                let marketCapChange = coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? ""
                let marketCapChangePercentage = coinModel.marketCapChangePercentage24H
                let marketCapStat = Statistic(title: "24h Marketcap Change", value: marketCapChange, percentageChange: marketCapChangePercentage)
                
                let blockTime = coinDetailsModel?.blockTimeInMinutes ?? 0
                let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
                let blockStat = Statistic(title: "Block Time", value: blockTimeString)
                
//                let hashing = coinDetailsModel?.hashingAlgorithm ??  "n/a"
//                let hashingStat = Statistic(title: "Hashing Algorithm,", value: hashing)
                
                
                let additionalArray : [Statistic] = [
                    highStat,lowhStat,priceChangeStat,marketCapStat, blockStat
                ]
                
                return (overViewArray, additionalArray)
                
            })
            .sink { [weak self] (overViewStats, additionalStats) in
                self?.overviewStatistics = overViewStats
                self?.additionalStatistics = additionalStats
            }
    }
}
