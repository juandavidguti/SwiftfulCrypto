//
//  CoinRowView.swift
//  SwiftfulCrypto
//
//  Created by Juan David Gutierrez Olarte on 11/08/25.
//

import SwiftUI



struct CoinRowView: View {
    
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
    }
}

#Preview("LightMode",traits: .sizeThatFitsLayout){
        CoinRowView(coin: dev.coin, showHoldingsColumn: true)
}
#Preview("DarkMode",traits: .sizeThatFitsLayout){
    CoinRowView(coin: dev.coin, showHoldingsColumn: true)
        .preferredColorScheme(.dark)
}


extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth:30)
            Circle()
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimal())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimal())
                .bold()
                .foregroundStyle(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0
                    ) >= 0 ? Color.theme.green
                    : Color.theme.red)
        }
        .frame(
            width: UIScreen.current.bounds.width / 3.5,
            alignment: .trailing
        )
    }
    
}
