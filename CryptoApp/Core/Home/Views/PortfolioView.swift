//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by Habibur Rahman on 14/1/24.
//

import SwiftUI

struct PortfolioView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarVIew(searchText: $vm.searchText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavbarItem
                }
            })
            .onChange(of: vm.searchText) { newValue in
                if newValue.isEmpty {
                    removeSelectedCoin()
                }
            }
        }
    }
    
    func updateSelectedCoin(coin : CoinModel){
        selectedCoin = coin
        if let portfolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}), let amount = portfolioCoin.currentHoldings {
            
            quantityText = "\(amount)"
        } else{
            quantityText = ""
        }
    }

    func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0.0
    }

    func saveBtnPressed() {
        guard let coin = selectedCoin , let amount = Double(quantityText) else { return }
        vm.updatePortfolio(coin: coin, amount: amount)

        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }

        UIApplication.shared.endEditing()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            showCheckmark = false
        }
        )
    }

    func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            PortfolioView()
                .environmentObject(DeveloperPreview.instance.homeVm)
        }
        
    }
}


extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1.0)
                        )
                }
            }.frame(height: 120)
                .padding(.leading)
        }
    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                    .lineLimit(1)

                Spacer()

                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
            }

            Divider()

            HStack {
                Text("Amount holding:")
                    .lineLimit(1)

                Spacer()

                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .frame(width: 100)
            }

            Divider()

            HStack {
                Text("Current value:")

                Spacer()

                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .font(.headline)
        .padding()
        .animation(nil, value: UUID())
    }

    private var trailingNavbarItem: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0)
            Button(action: {
                saveBtnPressed()
            }, label: {
                Text("SAVE")

            }).opacity(selectedCoin != nil ? 1.0 : 0.0)
            //.opacity(selectedCoin != nil && Double(quantityText) ?? 0 > 0 ? 1.0 : 0.0)

        }.font(.headline)
    }
}
