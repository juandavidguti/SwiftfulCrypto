//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 11/08/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticsModel] = [
        StatisticsModel(title: "Title", value: "Value",percentageChange: 1),
        StatisticsModel(title: "Title", value: "Value"),
        StatisticsModel(title: "Title", value: "Value"),
        StatisticsModel(title: "Title", value: "Value",percentageChange: -7),
    ]
    
    @Published var searchText: String = ""
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubscribers()
    }
    
    func addSubscribers() {
        
        // this function updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else {
            return coins
        }
        
        // transform in lowercase to be more effective in filtering
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel:MarketDataModel?) -> [StatisticsModel]{
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticsModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        
        let volume = StatisticsModel(
            title: "24h Volume",
            value: data.volume
        )
        let btcDominance = StatisticsModel(
            title: "BTC Dominance",
            value: data.btcDominance
        )
        let portfolio = StatisticsModel(
            title: "Portfolio Value",
            value: "$0.00",
            percentageChange: 0
        )
        stats
            .append(
                contentsOf: [marketCap,volume,btcDominance,portfolio]
            )
        return stats
    }
    
}
