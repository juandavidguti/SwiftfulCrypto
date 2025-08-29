//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 28/08/25.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil

    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellables)
        }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel],
                                                                                    additional: [StatisticsModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(
            coinDetailModel: coinDetailModel,
            coinModel: coinModel
        )
        return (overviewArray, additionalArray)
        
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticsModel] {
        // overview
        let price = coinModel.currentPrice.asCurrencyWith6Decimal()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticsModel(
            title: "Current Price",
            value: price,
            percentageChange: pricePercentageChange
        )
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticsModel(
            title: "Market Capitalization",
            value: marketCap,
            percentageChange: marketCapPercentageChange
        )
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        
        let volume = "$" + (
            coinModel.totalVolume?.formattedWithAbbreviations()
            ?? "")
        let volumeStat = StatisticsModel(
            title: "Volume",
            value: volume
        )
        
        let overviewArray: [StatisticsModel] = [priceStat,marketCapStat,rankStat,volumeStat]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticsModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimal() ?? "n/a"
        let highStat = StatisticsModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimal() ?? "n/a"
        let lowStat = StatisticsModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimal() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticsModel(
            title: "24h Price Change",
            value: priceChange
            , percentageChange: pricePercentChange2)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentage2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticsModel(
            title: "24h Market Cap Change",
            value: marketCapChange,
            percentageChange: marketCapChangePercentage2
        )
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticsModel(
            title: "Block Time",
            value: blockTimeString
        )
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticsModel(
            title: "Hashing Algorithm",
            value: hashing
        )
        
        let additionalArray: [StatisticsModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
    
}
