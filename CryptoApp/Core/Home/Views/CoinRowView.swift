//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 6/1/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingColumn: Bool

    var body: some View {
        HStack(spacing: 0) {
            leftColumn
                .frame(width: UIScreen.main.bounds.width/3)

            Spacer()

            if showHoldingColumn {
                middleColumn
                Spacer()
            }

            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        CoinRowView(coin: dev.coin, showHoldingColumn: true)
            .previewLayout(.sizeThatFits)
        
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)

            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)

            Text(coin.name)
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
        }
    }

    private var middleColumn: some View {
        VStack(alignment: .leading) {
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)

            Text((coin.currentHoldings ?? 0).asNumberString())
                .bold()
                .foregroundColor(coin.priceChangePercentage24HWithValue > 0 ? Color.theme.green : Color.theme.red)
        }
    }

    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)

            Text(coin.priceChangePercentage24HWithValue.asPercentString())
                .bold()
                .foregroundColor(coin.priceChangePercentage24HWithValue > 0 ? Color.theme.green : Color.theme.red)
        }
        //.frame(width: UIScreen.main.bounds.width / 3.5)
    }
}
