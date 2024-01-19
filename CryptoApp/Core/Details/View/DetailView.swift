//
//  DetailView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 18/1/24.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: CoinModel?

    var body: some View {
        if let coin = coin {
            DetailView(coin: coin)
        }
    }
}

struct DetailView: View {
    @StateObject var vm: DetailsViewModel

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    private let spacing: CGFloat = 30

    init(coin: CoinModel) {
        // self.coin = coin
        _vm = StateObject(wrappedValue: DetailsViewModel(coin: coin))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("")
                    .frame(height: 150)

                Text("Overview")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: spacing,
                    pinnedViews: []) {
                        ForEach(vm.overviewStatistics) {
                            stat in
                            StatisticView(statData: stat)
                        }
                    }

                Divider()
                
                
                
                Text("Additional Details")
                    .font(.title)
                    .bold()
                    .foregroundColor(Color.theme.accent)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Divider()

                LazyVGrid(
                    columns: columns,
                    alignment: .center,
                    spacing: spacing,
                    pinnedViews: []) {
                        ForEach(vm.additionalStatistics) {
                            stat in
                            StatisticView(statData: stat)
                        }
                    }

                Divider()
                
            }
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}
